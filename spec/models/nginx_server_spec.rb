# -*- coding: utf-8 -*-
require 'spec_helper'

describe NginxServer do
  before :each do
    @nginx_server = create(:nginx_server)
  end
  
  context '当 sftp user 属性完整时' do
    it '应该存储成功' do
      expect( @nginx_server.sftp_users.build( attributes_for(:sftp_user) ).save ).to be_true
    end
  end
  
  describe '在删除 nginx_server 时' do
    before :each do
      @nginx_server.sftp_users.create( attributes_for(:sftp_user) )
    end

    context '当存在关联的子对象时' do
      it '应该删除失败' do
        described_class.last.destroy.should be_false
      end
    end

    context '当没有关联的子对象时' do
      it '应该删除成功' do
        SftpUser.all.map(&:destroy)
        described_class.last.destroy.should be_true
      end
    end
  end
end
