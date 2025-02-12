# frozen_string_literal: true

module MidtransApi
  module Api
    module Merchant
      class Create < MidtransApi::Api::Base
        PATH = 'merchants'

        def post(params, partner_id)
          response = client.post(PATH, params, {
            'X-PARTNER-ID': partner_id
          })

          MidtransApi::Model::Merchant::Create.new(response)
        end
      end
    end
  end
end
