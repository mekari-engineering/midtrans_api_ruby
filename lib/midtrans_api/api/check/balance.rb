# frozen_string_literal: true

module MidtransApi
  module Api
    module Check
      class Balance < MidtransApi::Api::Base
        def get
          response = client.get("balance", {})
          MidtransApi::Model::Check::Balance.new(response)
        end
      end
    end
  end
end
