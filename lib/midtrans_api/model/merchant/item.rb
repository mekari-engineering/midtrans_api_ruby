# frozen_string_literal: true

module MidtransApi
  module Model
    module Merchant
      class Item < MidtransApi::Model::Base
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
