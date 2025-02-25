# frozen_string_literal: true

module MidtransApi
  module Api
    module Channel
      class List < MidtransApi::Api::Base
        PATH = 'iris/channels'

        # Get list of channels for specific merchant
        # [String] partner_id
        # [String] merchant_id
        # RESPONSE
        # [
        #   {
        #     "id":1,
        #     "virtual_account_type":"mandiri_bill_key",
        #     "virtual_account_number":"991385480006"
        #   },
        #   {
        #     "id":2,
        #     "virtual_account_type":"permata_virtual_account_number",
        #     "virtual_account_number":"8778003756104047"
        #   }
        # ]
        def get(partner_id, merchant_id)
          client.get(PATH, {}, {
            'X-PARTNER-ID': partner_id,
            'X-MERCHANT-ID': merchant_id
          })
        end
      end
    end
  end
end
