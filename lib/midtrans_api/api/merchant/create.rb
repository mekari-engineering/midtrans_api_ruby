# frozen_string_literal: true

module MidtransApi
  module Api
    module Merchant
      class Create < MidtransApi::Api::Base
        PATH = 'merchants'

        def post(params)
          response = client.post(PATH, params)

          MidtransApi::Model::Merchant::Create.new(response)
        end
      end
    end
  end
end
