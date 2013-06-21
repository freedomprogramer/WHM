# -*- coding: utf-8 -*-
module Concerns
  module Server
    extend ActiveSupport::Concern
    included do
      field :ip_address
      field :domain_name
      field :type
      field :state

      after_save :verify_server

      validates :ip_address, :domain_name, presence: true, uniqueness: true
      validates_format_of :ip_address, with:  /^((1?\d?\d|(2([0-4]\d|5[0-5])))\.){3}(1?\d?\d|(2([0-4]\d|5[0-5])))$/
      validates_format_of :domain_name, with: /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/

      state_machine :initial => :saved do
        event :verify_success do
          transition [:saved, :failure] => :success
        end

        # 删除成功后的状态转换
        event :verify_fail do
          transition [:saved, :success] => :failure      
        end
      end

      def verify_server
        # `ssh -o ConnectTimeout=1 root@vhostman.cdu.edu.cn ls`
        `ls /home`
        $?.exitstatus == 0 ? verify_success : verify_fail
      end
    end

  end
end
