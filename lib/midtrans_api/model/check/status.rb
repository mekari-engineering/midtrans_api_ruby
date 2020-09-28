# frozen_string_literal: true

module MidtransApi
  module Model
    module Check
      class Status < MidtransApi::Model::Base
        resource_attributes :transaction_time,
                            :transaction_id,
                            :gross_amount,
                            :currency,
                            :order_id,
                            :payment_type,
                            :signature_key,
                            :status_code,
                            :transaction_status,
                            :fraud_status,
                            :status_message,
                            :settlement_time,
                            :masked_card,
                            :merchant_id,
                            :bank,
                            :approval_code,
                            :channel_response_code,
                            :channel_response_message,
                            :card_type,
                            :refund_amount,
                            :refunds,
                            :refund_chargeback_id,
                            :created_at,
                            :reason,
                            :refund_key,
                            :refund_method,
                            :bank_confirmed_at

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
