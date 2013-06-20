# -*- coding: utf-8 -*-

module Concerns
  module Association
    extend ActiveSupport::Concern
    included do
      before_validation :find_associated_object
    end
    
    module ClassMethods
      def validates_exist_associated_object *fields
        define_method :find_associated_object do
          
          fields.each do |field|
            raise ArgumentError, "Argument must be Symbol "  unless field.is_a? Symbol
            field_value =  self.send field

            # 如果 关联对象的指为空 或者 找不到关联对象，则添加错误 :not_exist
            unless field_value && 
                Object.const_get( field.to_s.camelize ).find( field_value )
              errors.add( field, :not_exist )
            end
          end

          # 如果有错误信息，直接验证失败
          errors.messages.size > 0 ? false : true          
        end
        
      end
    end
  end
end
