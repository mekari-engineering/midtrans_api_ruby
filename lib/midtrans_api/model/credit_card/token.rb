# frozen_string_literal: true

module MidtransApi
  module Model
    module CreditCard
      class Token < MidtransApi::Model::Base
        resource_attributes :status_code,
                            :status_message,
                            :token_id,
                            :hash

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
