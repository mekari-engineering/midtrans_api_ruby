# frozen_string_literal: true

module MidtransApi
  module Api
    module Check
      class Status < MidtransApi::Api::Base
        def get(order_id:)
          response = client.get("#{order_id}/status", {})
          MidtransApi::Model::Check::Status.new(response)
        end
      end
    end
  end
end
