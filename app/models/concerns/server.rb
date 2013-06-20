# -*- coding: utf-8 -*-
module Concerns
  module Server
    extend ActiveSupport::Concern
    included do
      field :ip_string
      field :domain_name

      validates :ip_string, :domain_name, presence: true, uniqueness: true
      validates_format_of :ip_string, with:  /^((1?\d?\d|(2([0-4]\d|5[0-5])))\.){3}(1?\d?\d|(2([0-4]\d|5[0-5])))$/
      validates_format_of :domain_name, with: /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/
    end
    
    # 虚拟 ip 属性，返回一个 IPAddress 对象
    def ip
      IPAddress ip_string
    end
    
    def ip= value
      self.ip_string = value
    end
  end
end
