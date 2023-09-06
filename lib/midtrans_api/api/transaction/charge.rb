# frozen_string_literal: true

module MidtransApi
  module Api
    module Transaction
      class Charge < MidtransApi::Api::Base
        PATH          = 'charge'

        # @payment_type: "bank_transfer"|"echannel"
        def post(params, payment_type)
          response = client.post(PATH, build_params(params, payment_type))

          MidtransApi::Model::Transaction::Charge.new(response)
        end

        private

        def build_params(params, payment_type)
          {
            payment_type: payment_type,
            transaction_details: params[:transaction_details]
          }.tap do |p|
            p[:bank_transfer] = params[:bank_transfer] if payment_type == "bank_transfer"
            p[:echannel] = params[:echannel] if payment_type == "echannel"
            p[:customer_details] = params[:customer_details] unless params[:customer_details].nil?
            p[:item_details] = params[:item_details] unless params[:item_details].nil?
            p[:custom_expiry] = params[:custom_expiry] unless params[:custom_expiry].nil?
          end
        end
      end
    end
  end
end
