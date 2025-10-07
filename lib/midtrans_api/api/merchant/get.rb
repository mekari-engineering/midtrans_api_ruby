# frozen_string_literal: true

module MidtransApi
  module Api
    module Merchant
      class Get < MidtransApi::Api::Base
        PATH = 'merchants'

        def get(params, partner_id)
          response = client.get(PATH, params, {
            'X-PARTNER-ID': partner_id
          })

          MidtransApi::Model::Merchant::Get.new(response)
        end
      end
    end
  end
end
