# -*- coding: utf-8 -*-
require 'spec_helper'

describe SftpUser do
  
  context '当 nginx server ID 为空时' do
    it '应该验证失败' do
      expect( described_class.new( attributes_for(:sftp_user))).to have(1).error_on :nginx_server
      build( :sftp_user ).save.should be_true
    end
  end
  
  context '当 nginx server ID 不为空，但不是有效数据时' do
    it '应该验证失败' do
      expect( described_class.new( attributes_for(:sftp_user).merge( nginx_server: build(:nginx_server).id )))
        .to have(1).error_on :nginx_server
    end
  end
  
  context '当 home_directory 为空时' do
    it '应该自动生成以 配置文件中 Settings.puppet.sftp.top_home_directory + username 的主目录' do
      build( :sftp_user ).save.should be_true
      expect( described_class.last.home_directory )
        .to eq File.join( Settings.puppet.sftp.top_home_directory, attributes_for(:sftp_user)[:username] )
    end
  end

  it '用 expect 测试' do
    build(:sftp_user).save.should be_true
    # 不能 ssh 登陆
    Expect::SSH.new('tom', '12345678', 'sftp.example.com').can_ssh_login?.should be_false
    # 可以 sftp 登陆
    Expect::SSH.new('tom', '12345678', 'sftp.example.com').can_sftp_login?.should be_true

    described_class.last.destroy.should be_true
    # 不能登陆
    Expect::SSH.new('tom', '12345678', 'sftp.example.com').can_login?.should be_false
  end
end
