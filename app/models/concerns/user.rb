# -*- coding: utf-8 -*-
require 'securerandom'

module Concerns
  module User
    extend ActiveSupport::Concern
    included do
      field :username
      field :password
      field :password_confirmation

      validates_presence_of :username, :password, :password_confirmation
      validates :username, format: { without: /\W+/ }, uniqueness: true
      validates :password, length: { minimum: 8, maximum: 16 }, confirmation: true

      # 保存密码之前，加密密码； 重写 encrypt_password 方法以改变密码加密方式
      before_save :encrypt_password
      def encrypt_password; end
      
      private
      # 产生指定 length 的随机字符串
      def random_string length
        SecureRandom.hex length
      end
    end
  end
end
