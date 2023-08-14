# frozen_string_literal: true

module MidtransApi
  module Model
    module Check
      class Balance < MidtransApi::Model::Base
        resource_attributes :balance

        def resolve_params_attr(attr)
          attr.to_s
        end
      end
    end
  end
end
