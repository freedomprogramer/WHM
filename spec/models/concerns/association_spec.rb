# -*- coding: utf-8 -*-
require 'spec_helper'

class AssociationConcern
  include Mongoid::Document
  has_many :association_concern_tests, :inverse_of => :association_concern
end

class AssociationConcernTest
  include Mongoid::Document
  include Concerns::Association
  belongs_to :association_concern, :inverse_of => :association_concern_tests
  validates_exist_associated_object :association_concern  
end

describe AssociationConcernTest do

  context '当关联对象不存在时' do
    it '应该验证失败' do
      expect( described_class.new ).to have(1).error_on :association_concern
      expect( described_class.new(:association_concern => AssociationConcern.new) ).to have(1).error_on :association_concern      
    end
  end
  
  context '当关联对象存在时' do
    it '应该保存成功' do 
      described_class.new( :association_concern => AssociationConcern.create.id ).save.should be_true
    end
  end
end
