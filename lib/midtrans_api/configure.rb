# frozen_string_literal: true

module MidtransApi
  class Configure
    attr_accessor :client_key,
                  :server_key,
                  :notification_url,
                  :midtrans_env
    attr_reader   :api_version

    def initialize(options = {})
      @client_key       = options[:client_key]
      @server_key       = options[:server_key]
      @notification_url = options[:notification_url] || nil
      @midtrans_env     = options[:midtrans_env] || 'production'
      @api_version      = :v2
    end

    def api_url
      return MidtransApi::API_PRODUCTION_URL if midtrans_env.eql? 'production'

      MidtransApi::API_SANDBOX_URL
    end
  end
end
