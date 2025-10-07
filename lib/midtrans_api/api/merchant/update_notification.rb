# frozen_string_literal: true

module MidtransApi
  module Api
    module Merchant
      class UpdateNotification < MidtransApi::Api::Base
        PATH = 'merchants/notifications'

        def patch(params, partner_id, merchant_id)
          response = client.patch(PATH, params, {
            'X-PARTNER-ID': partner_id,
            'X-MERCHANT-ID': merchant_id
          })

          MidtransApi::Model::Merchant::UpdateNotification.new(response)
        end
      end
    end
  end
end
