# -*- coding: utf-8 -*-
require 'spec_helper'

class PuppetConcernTest
  include Mongoid::Document
  include Concerns::Puppet

  execute_puppet_after_save do
    add_sftp_user 'sftp.example.com', DataHelper.sftp_user
    add_site 'sftp.example.com', DataHelper.site
    add_dns_record 'dns.example.com', DataHelper.dns_record
  end

  execute_puppet_before_destroy do    
    del_site 'sftp.example.com', DataHelper.site
    del_sftp_user 'sftp.example.com', DataHelper.sftp_user
    del_dns_record 'dns.example.com', DataHelper.dns_record
  end
end

describe PuppetConcernTest do

  context '当执行添加操作是' do
    it '应该产生如下影响' do
      described_class.new.save.should be_true
      # 不能 ssh 登陆
      Expect::SSH.new('tom', '12345678', 'sftp.example.com').can_ssh_login?.should be_false
      # 可以 sftp 登陆
      Expect::SSH.new('tom', '12345678', 'sftp.example.com').can_sftp_login?.should be_true
      # 可以在 DNS 上查询到 新域名
      Expect::DNS.new('dns.example.com').nslookup('blog.example.com', '192.168.122.102').should_not be_nil
      # 可以通过 新域名 访问站点
      expect( Expect::Nginx.request('blog.example.com').code ).to eql '200'

      described_class.last.destroy.should be_true
      # 不能登陆
      Expect::SSH.new('tom', '12345678', 'sftp.example.com').can_login?.should be_false
      # 不能在 DNS 上查询到域名记录
      Expect::DNS.new('dns.example.com').nslookup('blog.example.com', '192.168.122.102').should be_nil
      # 不能通过 新域名 访问站点
      expect( Expect::Nginx.request('blog.example.com') ).to be_false
    end
  end  
end

### -------------------------------虚拟数据-----------------------------------
class DataHelper
  class << self
    def sftp_user
      {'username' => 'tom', 'password' => 'H2pO6QfkcV64I', 'home_directory' =>  '/var/www/tom'}
    end

    def dns_record
      {'site_name' => 'blog', 'ip' => '192.168.122.102', 'record_file_path' => '/etc/bind/db.example'}
    end

    def site
      {'site_name' => 'blog', 'site_root_directory' => '/var/www/tom/blog'}
    end
  end
end
