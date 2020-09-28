# frozen_string_literal: true

module MidtransApi
  module Model
    module CreditCard
      class Charge < MidtransApi::Model::Base
        resource_attributes :status_code,
                            :approval_code,
                            :transaction_id,
                            :order_id,
                            :status_message,
                            :payment_type,
                            :gross_amount,
                            :transaction_status,
                            :transaction_time,
                            :actions,
                            :merchant_id,
                            :currency,
                            :channel_response_code,
                            :channel_response_message,
                            :fraud_status,
                            :bank,
                            :redirect_url,
                            :masked_card,
                            :card_type,
                            :installment_term

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
