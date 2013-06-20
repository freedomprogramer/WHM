# -*- coding: utf-8 -*-

module Concerns
  module Restriction
    extend ActiveSupport::Concern
    included do

      # 重写 destroy 方法，捕获 :dependent => :restrict 抛出的异常
      def destroy
        begin
          super
        rescue Mongoid::Errors::DeleteRestriction
          # Return false if it have child document
          false
        end
      end

    end
  end
end
