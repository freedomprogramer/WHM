# -*- coding: utf-8 -*-
require 'spec_helper'

describe DnsServer do
  
  before :each do
    @php_app_hash = {sftp_user_id: create(:sftp_user).id, site_name: 'blog'}
    @dns_server = create(:dns_server)
  end

  context '当 :record_file_path 或 :zone 为空时' do
    it '应该验证失败' do
      expect( described_class.new( attributes_for(:dns_server).except :record_file_path )).to have(1).error_on :record_file_path
      expect( described_class.new( attributes_for(:dns_server).except :zone )).to have(1).error_on :zone
    end
  end
  
  context '当 php_app 属性完整时' do
    it '应该存储成功' do      
      expect( @dns_server.php_apps.build( @php_app_hash ).save ).to be_true
    end
  end

  describe '在删除 dns_server 时' do
    before :each do
      @dns_server.php_apps.create( @php_app_hash )
    end

    context '当存在关联的子对象时' do
      it '应该删除失败' do
        described_class.last.destroy.should be_false
      end
    end

    context '当没有关联的子对象时' do
      it '应该删除成功' do
        PhpApp.all.map(&:destroy)
        described_class.last.destroy.should be_true
      end
    end
  end

end
