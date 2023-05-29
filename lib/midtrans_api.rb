# frozen_string_literal: true

module MidtransApi
  API_PRODUCTION_URL = 'https://api.midtrans.com'
  # API_SANDBOX_URL = 'https://api.sandbox.midtrans.com'
  API_SANDBOX_URL = 'https://midtrans-cc.free.beeceptor.com'

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= MidtransApi::Configure.new
    yield(configuration)
  end
end

require 'midtrans_api/errors'
require 'midtrans_api/client'
require 'midtrans_api/configure'
