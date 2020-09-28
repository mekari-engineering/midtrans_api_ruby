# frozen_string_literal: true

module MidtransApi
  module Api
    module Gopay
      class Charge < MidtransApi::Api::Base
        PATH          = 'charge'
        PAYMENT_TYPE  = 'gopay'

        def post(params)
          gopay_params = {}

          unless client.config.notification_url.nil?
            gopay_params = {
              enable_callback: true,
              callback_url: client.config.notification_url
            }
          end

          response = client.post(PATH,
                                 transaction_details: params[:transaction_details],
                                 item_details: params[:item_details],
                                 customer_details: params[:customer_details],
                                 payment_type: PAYMENT_TYPE,
                                 gopay: gopay_params)
          MidtransApi::Model::Gopay::Charge.new(response)
        end
      end
    end
  end
end
