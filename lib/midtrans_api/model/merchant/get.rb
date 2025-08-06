# frozen_string_literal: true

require_relative 'item'

module MidtransApi
  module Model
    module Merchant
      class Get < MidtransApi::Model::Base
        resource_attributes :merchants

        def resolve_params_attr(attr)
          attr.to_s
        end

        def merchant_list
          return [] unless merchants

          merchants.map do |merchant_data|
            Item.new(merchant_data)
          end
        end
      end
    end
  end
end
