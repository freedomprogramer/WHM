# -*- coding: utf-8 -*-
module Concerns
  module Verify
    extend ActiveSupport::Concern
    included do
      def ssh_login domain, command
        `ssh -o ConnectTimeout=1 -o PasswordAuthentication=no root@#{domain} #{command}`.chomp
      end

      def verify_method; end

      def verify
        result = verify_method        # execute verify
        raise NoMethodError, 'Please define method "verify_method"' if result == nil
        if result == true
          self.set :state, 'usable'
        elsif result == false
          self.set :state, 'useless'
        end
      end
    end
  end
end
