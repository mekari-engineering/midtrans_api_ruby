# frozen_string_literal: true

module MidtransApi
  module Api
    module Transaction
      class ChargeEchannel < MidtransApi::Api::Base
        PATH          = 'charge'
        PAYMENT_TYPE  = 'echannel'

        def post(params)
          response = client.post(PATH, build_params(params))

          MidtransApi::Model::Transaction::ChargeEchannel.new(response)
        end

        private

        def build_params(params)
          {
            payment_type: PAYMENT_TYPE,
            transaction_details: params[:transaction_details],
            echannel: params[:echannel],
          }.tap do |p|
            p[:customer_details] = params[:customer_details] unless params[:customer_details].nil?
            p[:item_details] = params[:item_details] unless params[:item_details].nil?
            p[:custom_expiry] = params[:custom_expiry] unless params[:custom_expiry].nil?
          end
        end
      end
    end
  end
end
