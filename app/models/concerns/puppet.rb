# -*- coding: utf-8 -*-
require 'erb'
require 'open3'

module Concerns
  module Puppet
    extend ActiveSupport::Concern
    included do
      field :state
      field :puppet_log
      
      # :rollback_status 判断第一次执行命令后是否成功，来确定是否需要回滚；并保存 回滚 后的状态
      field :rollback_status, default: true

      set_callback :save, :after, :add_and_check_status, :if => :saved?
      set_callback :destroy, :before, :del_and_check_status #, :if => :effective?
      set_callback :destroy, :before, :useless?

      state_machine :initial => :saved do
        # 添加成功后状态转换
        event :effect do
          transition :saved => :effective
        end

        # 删除成功后的状态转换
        event :invalid do
          transition :effective => :useless      
        end
      end

      def ssh_remote_push domain_name
        # command = "ssh -o ConnectTimeout=1 root@#{domain_name} puppet agent --server #{Settings.puppet.master_domain} --test"
        command = 'ssh root@vhostman.cdu.edu.cn ls'
        Open3.popen3( command ) do |stdin, stdout, stderr, wait_thr|
          self.add_to_set :puppet_log, stdout.inject("----------stdout----------\n"){|sum, n| sum + n }
          self.add_to_set :puppet_log, stderr.inject("----------stderr----------\n"){ |sum, n| sum + n}

          # 保存执行状态
          puts 'exitstatus code ================> ' + wait_thr.value.exitstatus.to_s
          exitstatus = ([0,2].include? wait_thr.value.exitstatus) ? true : false
          self.set :rollback_status, (exitstatus && self.rollback_status )
        end
      end

      # 如果 args 的最后一个参数是 Hash， 则把 Hash 合并到 serializable_hash
      def invoke_hiera_factory method_name, *args
        PuppetLab::HieraFactory.new( args.first )
          .send method_name, args.last.is_a?(Hash) ? args.last.merge(serializable_hash) : serializable_hash

        ssh_remote_push args.first
      end

      # 执行 添加操作后判断执行是否成功。如果成功就改变 状态为 effective; 如果执行失败则撤销刚才执行的操作
      def add_and_check_status
        after_save_invoke_method

        puts 'rollback_status boolean ============> ' + self.rollback_status.to_s
        if self.rollback_status
          self.set :state, 'effective'
        else
          self.rollback_status = true
          before_destroy_invoke_method
        end
      end

      # 执行 删除操作后判断执行是否成功。如果成功就改变 状态为 useless; 如果执行失败则撤销刚才执行的操作
      def del_and_check_status
        before_destroy_invoke_method

        puts 'rollback_status boolean ============> ' + self.rollback_status.to_s
        if self.rollback_status
          self.set :state, 'useless'
        else
          self.rollback_status = true
          after_save_invoke_method
        end
      end

      def method_missing method_name, *args
        # 如果 hiera 模板存在，就调用与模板名相同的方法；如果不存在调用 super
        if PuppetLab::HieraFactory.hiera_templates.include? method_name.to_s
          if args.first.is_a? String
            invoke_hiera_factory method_name, *args
          else
            raise ArgumentError, "First argument must be string, options second argument must be hash"
          end
        else
          super
        end

      end
    end

    module ClassMethods
      def execute_puppet_after_save &block
        define_method :after_save_invoke_method, block
      end

      def execute_puppet_before_destroy &block
        define_method :before_destroy_invoke_method, block
      end
    end

  end
end
