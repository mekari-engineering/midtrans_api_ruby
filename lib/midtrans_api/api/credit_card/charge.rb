# frozen_string_literal: true

module MidtransApi
  module Api
    module CreditCard
      class Charge < MidtransApi::Api::Base
        PATH = 'charge'
        PAYMENT_TYPE = 'credit_card'

        def post(params)
          response = client.post(PATH, params)

          MidtransApi::Model::CreditCard::Charge.new(response)
        end
      end
    end
  end
end
