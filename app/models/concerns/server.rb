# -*- coding: utf-8 -*-
module Concerns
  module Server
    extend ActiveSupport::Concern
    included do
      field :ip_address
      field :domain_name
      field :type
      field :state

      validates :ip_address, :domain_name, presence: true, uniqueness: true
      validates_format_of :ip_address, with:  /^((1?\d?\d|(2([0-4]\d|5[0-5])))\.){3}(1?\d?\d|(2([0-4]\d|5[0-5])))$/
      validates_format_of :domain_name, with: /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/

      # Callback
      execute_puppet_after_save do
        verify_server domain_name
      end

      execute_puppet_before_destroy do;end
    end

  end
end
