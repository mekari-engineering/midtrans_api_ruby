# frozen_string_literal: true

module MidtransApi
  module Api
    module BcaVirtualAccount
      class Charge < MidtransApi::Api::Base
        PATH          = 'charge'
        PAYMENT_TYPE  = 'bank_transfer'

        def post(params)
          response = client.post(PATH,
                                 bank_transfer: params[:bank_transfer],
                                 bca: params[:bca],
                                 customer_details: params[:customer_details],
                                 item_details: params[:item_details],
                                 payment_type: PAYMENT_TYPE,
                                 transaction_details: params[:transaction_details])

          MidtransApi::Model::BcaVirtualAccount::Charge.new(response)
        end
      end
    end
  end
end
