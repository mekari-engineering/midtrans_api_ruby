# frozen_string_literal: true

module MidtransApi
  module Api
    module CreditCard
      class Charge < MidtransApi::Api::Base
        PATH = 'charge'
        PAYMENT_TYPE = 'credit_card'

        def post(params)
          response = client.post(PATH,
                                 transaction_details: params[:transaction_details],
                                 item_details: params[:item_details],
                                 customer_details: params[:customer_details],
                                 payment_type: PAYMENT_TYPE,
                                 credit_card: params[:credit_card])
          MidtransApi::Model::CreditCard::Charge.new(response)
        end
      end
    end
  end
end
