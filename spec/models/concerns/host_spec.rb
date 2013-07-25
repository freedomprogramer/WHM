 # -*- coding: utf-8 -*-
 require 'spec_helper'

 class HostConcernTest
   include Mongoid::Document
   include Concerns::Host
 end

 describe HostConcernTest do

   before :each do
     described_class.new( legal_date ).save.should be_true
   end

   context '当获取 ip 的值时' do
     it '应该返回一个 IPAddress 对象' do
       expect( HostConcernTest.last.ip ).to be_an_instance_of IPAddress::IPv4
     end
   end

   context '当再次存入一个 ip 或 domain_name 相同的数据时' do
     it '应该验证失败' do
       expect( described_class.new( legal_date ).save ).to be_false
     end
   end

   context '当属性 ip 或 domain_name 值为空时' do
     it '应该验证失败' do
       expect( described_class.new( no_ip )).to have(2).error_on :ip_string
       expect( described_class.new( no_domain_name )).to have(2).error_on :domain_name
     end
   end

   context '当 ip 或 domain_name 不合法时' do
     it '应该验证失败' do
       ['illegal ip', '192.168.1.256'].each do |ip|
         legal_date[:ip] = ip
         expect( described_class.new( legal_date )).to have(1).error_on :ip_string
       end
     end
     
     it '应该验证失败' do
       ['www_', 'test.'].each do |ip|
         legal_date[:domain_name] = ip
         expect( described_class.new( legal_date )).to have(1).error_on :domain_name
       end
     end
   end
   
   ### -------------------------------虚拟数据-----------------------------------
   let!(:legal_date) do
     { ip: '192.168.1.1', domain_name: 'test.example.com' }
   end
   
   let!(:no_ip) do
     { domain_name: 'test.example.com' }
   end
   
   let!(:no_domain_name) do
     { ip: '192.168.1.1' }
   end
 end
