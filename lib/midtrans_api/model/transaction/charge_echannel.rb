# frozen_string_literal: true

module MidtransApi
  module Model
    module Transaction
      class ChargeEchannel < MidtransApi::Model::Base
        resource_attributes :status_code,
                            :status_message,
                            :transaction_id,
                            :order_id,
                            :gross_amount,
                            :payment_type,
                            :transaction_time,
                            :transaction_status,
                            :fraud_status,
                            :currency,
                            :signature_key,
                            :expiry_time,
                            :bill_key,
                            :biller_code,
                            :approval_code

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
