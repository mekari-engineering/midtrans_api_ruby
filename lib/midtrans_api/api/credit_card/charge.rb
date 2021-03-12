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
          credit_card_params = permitted_credit_card_params(response)
          MidtransApi::Model::CreditCard::Charge.new(credit_card_params)
        end

        def permitted_credit_card_params(response)
          {
            'status_code' => response['status_code'],
            'approval_code' => response['approval_code'],
            'transaction_id' => response['transaction_id'],
            'order_id' => response['order_id'],
            'status_message' => response['status_message'],
            'payment_type' => response['payment_type'],
            'gross_amount' => response['gross_amount'],
            'transaction_status' => response['transaction_status'],
            'transaction_time' => response['transaction_time'],
            'actions' => response['actions'],
            'merchant_id' => response['merchant_id'],
            'currency' => response['currency'],
            'channel_response_code' => response['channel_response_code'],
            'channel_response_message' => response['channel_response_message'],
            'fraud_status' => response['fraud_status'],
            'bank' => response['bank'],
            'redirect_url' => response['redirect_url'],
            'masked_card' => response['masked_card'],
            'card_type' => response['card_type'],
            'installment_term' => response['installment_term'],
            'payload' => response.to_json
          }
        end
      end
    end
  end
end
