# frozen_string_literal: true

module MidtransApi
  module Model
    class Base
      class << self
        def attribute_keys
          @attribute_keys ||= []
        end

        private

        def resource_attributes(*attributes)
          attributes.each { |attribute| attr_accessor attribute }
          attribute_keys.concat(attributes)
        end
      end

      def initialize(params)
        assign_attributes(params)
      end

      def instance_values
        Hash[instance_variables.map { |name| [name[1..-1], instance_variable_get(name)] }]
      end

      private

      def assign_attributes(params)
        self.class.attribute_keys.each do |attr|
          resolved_attr = resolve_params_attr(attr)

          unless params[resolved_attr].nil?
            __send__("#{attr}=", params[resolved_attr])
          end
        end
      end
    end
  end
end
