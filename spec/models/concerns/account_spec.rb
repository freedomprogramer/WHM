# -*- coding: utf-8 -*-
require 'spec_helper'
 
class AccountConcernTest
  include Mongoid::Document
  include Concerns::Account
end

describe AccountConcernTest do

  before :each do
    described_class.new( legal_date ).save.should be_true
  end
  
  context '当再次存入一个 username 相同的数据时' do
    it '应该验证失败' do
      expect( described_class.new( legal_date )).to have(1).error_on :username
    end
  end

  context '当属性 username、 password 或 password_comfirmation 值为空时' do
    it '应该验证失败' do
      expect( described_class.new( no_username )).to have(1).error_on :username
      expect( described_class.new( no_password )).to have(3).error_on :password
      expect( described_class.new( no_password_confirmation )).to have(1).error_on :password_confirmation
    end
  end

  context '当 username 的值不是字母、数字、下划线时' do
    it '应该验证失败' do
      "!@$%^&*()-+=[]{}\|;:',./<>?~".each_char do | str |
        legal_date[:username] = str + 'tom'
        expect( described_class.new( legal_date )).to have(1).error_on :username
      end
    end
  end

  context '当 password 长度小于 8、大于 16 时' do
    it '应该验证失败' do
      ['1234567', '12345678123456789'].each do | value |
        legal_date[:password] = value
        expect( described_class.new( legal_date  )).to have(2).error_on( :password )
      end      
    end
  end

  context '当 password 与 password_confirmation 不匹配时' do
    it '应该验证失败' do
      legal_date[:password] = '12345678'
      legal_date[:password_confirmation] = '87654321'
      expect( described_class.new( legal_date )).to have(1).error_on( :password )
    end
  end

  ### -------------------------------虚拟数据-----------------------------------
  let!(:legal_date) do
    { username: 'tom', password: '12345678', password_confirmation: '12345678' }
  end
  
  let!(:no_username) do
    { password: '12345678', password_confirmation: '12345678' }
  end
  
  let!(:no_password) do
    { username: 'tom', password_confirmation: '12345678' }
  end
  
  let!(:no_password_confirmation) do
    { username: 'tom', password: '12345678' }
  end
end
