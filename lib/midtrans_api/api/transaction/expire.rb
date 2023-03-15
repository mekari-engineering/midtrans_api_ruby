# frozen_string_literal: true

module MidtransApi
  module Api
    module Transaction
      class Expire < MidtransApi::Api::Base

        def post(order_id:)
          response = client.post("#{order_id}/expire",{})

          MidtransApi::Model::Transaction::Expire.new(response)
        end
      end
    end
  end
end
