# frozen_string_literal: true

module MidtransApi
  module Model
    module Transaction
      class Expire < MidtransApi::Model::Base
        resource_attributes :gross_amount,
                            :order_id,
                            :payment_type,
                            :status_code,
                            :status_message,
                            :transaction_id,
                            :transaction_status,
                            :transaction_time

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
