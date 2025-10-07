# frozen_string_literal: true

module MidtransApi
  module Model
    module Merchant
      class UpdateNotification < MidtransApi::Model::Base
        resource_attributes :status_code,
                            :status_message,
                            :payment_notification_url,
                            :iris_notification_url,
                            :recurring_notification_url,
                            :pay_account_notification_url,
                            :finish_payment_redirect_url

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
