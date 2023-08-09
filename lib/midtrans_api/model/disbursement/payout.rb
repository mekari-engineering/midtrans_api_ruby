# frozen_string_literal: true

module MidtransApi
  module Model
    module Disbursement
      class Payout < MidtransApi::Model::Base
        resource_attributes :payouts

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
