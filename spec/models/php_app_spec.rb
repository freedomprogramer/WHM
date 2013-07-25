# -*- coding: utf-8 -*-
require 'spec_helper'

describe PhpApp do

  context '当 sftp user 不存在时' do
    it '应该验证失败' do      
      expect( described_class.new( attributes_for(:php_app))).to have(1).error_on :sftp_user
      expect( described_class.create( attributes_for(:php_app).merge( sftp_user: build(:sftp_user) )))
        .to have(1).error_on :sftp_user
    end
  end

  context '当 dns_server 不存在时' do
    it '因改验证失败' do
      expect( described_class.new( attributes_for(:php_app))).to have(1).error_on :dns_server
      expect( described_class.create( attributes_for(:php_app).merge( sftp_user: build(:dns_server).id )))
        .to have(1).error_on :dns_server
    end
  end

  describe '当 sftp_user 和 dns_server 都存在时' do
    before :each do
      @php_app_hash = create(:php_app).serializable_hash.except '_id'
    end

    context '当 site_name 或 site_domain 为空时' do
      it '应该验证失败' do
        expect( described_class.new( @php_app_hash.except 'site_name' ) ).to have(1).error_on :site_name
        
      end
    end

    context '当 site_name 或 site_root_directory 相同时' do
      it '应该验证失败' do
        expect( described_class.new( @php_app_hash ) ).to have(1).error_on :site_name
        expect( described_class.new( @php_app_hash ) ).to have(1).error_on :site_root_directory
      end
    end
    
    context '当 site_root_directory  为空时' do
      it '应该自动生成以配置文件中 Settings.puppet.sftp.top_home_directory + username 的主目录' do
        expect( described_class.last.site_root_directory )
          .to eq File.join( SftpUser.last.home_directory, attributes_for(:php_app)[:site_name] )
      end
    end

    context '当 site_domain 为空时' do      
      it '应该自动生成以 site_name + dns_server 的 zone 为 site_domain' do
        expect( described_class.last.site_domain )
          .to eq described_class.last.site_name + '.' +  DnsServer.last.zone
      end
    end
  end

  it '用 expect 测试' do
    build(:php_app).save.should be_true
    # 可以在 DNS 上查询到 新域名
    Expect::DNS.new('dns.example.com').nslookup('blog.example.com', '192.168.122.102').should_not be_nil
    # 可以通过 新域名 访问站点
    expect( Expect::Nginx.request('blog.example.com').code ).to eql '200'

    described_class.last.destroy.should be_true
    # 不能在 DNS 上查询到域名记录
    Expect::DNS.new('dns.example.com').nslookup('blog.example.com', '192.168.122.102').should be_nil
    # 不能通过 新域名 访问站点
    expect( Expect::Nginx.request('blog.example.com') ).to be_false
  end
end
