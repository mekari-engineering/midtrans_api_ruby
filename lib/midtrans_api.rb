# frozen_string_literal: true

module MidtransApi
  API_PRODUCTION_URL = 'https://api.midtrans.com'
  API_SANDBOX_URL = 'https://api.sandbox.midtrans.com'
end

require 'midtrans_api/errors'
require 'midtrans_api/client'
require 'midtrans_api/configure'
