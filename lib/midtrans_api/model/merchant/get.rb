# frozen_string_literal: true

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
            MerchantItem.new(merchant_data)
          end
        end

        # Inner class to represent individual merchant items
        class MerchantItem
          attr_reader :merchant_id, :merchant_name, :merchant_phone_number, :email

          def initialize(merchant_data)
            @merchant_id = merchant_data['merchant_id']
            @merchant_name = merchant_data['merchant_name']
            @merchant_phone_number = merchant_data['merchant_phone_number']
            @email = merchant_data['email']
          end

          def to_h
            {
              merchant_id: merchant_id,
              merchant_name: merchant_name,
              merchant_phone_number: merchant_phone_number,
              email: email
            }
          end
        end
      end
    end
  end
end
