# frozen_string_literal: true

module MidtransApi
  module Api
    module Transaction
      class Charge < MidtransApi::Api::Base
        PATH          = 'charge'
        PAYMENT_TYPE  = 'bank_transfer'

        def post(params)
          response = client.post(PATH, build_params(params))

          MidtransApi::Model::Transaction::Charge.new(response)
        end

        private

        def build_params(params)
          {
            payment_type: PAYMENT_TYPE,
            bank_transfer: params[:bank_transfer],
            transaction_details: params[:transaction_details],
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
