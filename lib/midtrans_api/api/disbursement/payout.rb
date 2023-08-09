# frozen_string_literal: true

module MidtransApi
  module Api
    module Disbursement
      class Payout < MidtransApi::Api::Base
        PATH          = 'payouts'

        def post(params)
          response = client.post(PATH, params)

          MidtransApi::Model::Disbursement::Payout.new(response)
        end
      end
    end
  end
end
