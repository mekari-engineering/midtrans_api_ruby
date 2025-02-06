# frozen_string_literal: true

module MidtransApi
  module Model
    module Merchant
      class Create < MidtransApi::Model::Base
        resource_attributes :status_code,
                            :status_message,
                            :merchant_id,
                            :merchant_name,
                            :merchant_phone_number,
                            :email,
                            :callback_url,
                            :notification_url,
                            :pay_account_url,
                            :owner_name,
                            :mcc,
                            :entity_type,
                            :business_name

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
