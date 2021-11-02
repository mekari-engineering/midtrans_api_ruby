# frozen_string_literal: true

module MidtransApi
  module Model
    module BcaVirtualAccount
      class Charge < MidtransApi::Model::Base
        resource_attributes :currency,
                            :fraud_status,
                            :gross_amount,
                            :order_id,
                            :payment_type,
                            :signature_key,
                            :status_code,
                            :status_message,
                            :transaction_id,
                            :transaction_status,
                            :transaction_time,
                            :va_numbers

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
