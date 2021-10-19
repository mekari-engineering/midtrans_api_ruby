# frozen_string_literal: true

module MidtransApi
  class Configure
    attr_accessor :client_key,
                  :server_key,
                  :notification_url,
                  :sandbox_mode,
                  :logger
    attr_reader   :api_version

    def initialize(options = {})
      @client_key       = options[:client_key]
      @server_key       = options[:server_key]
      @notification_url = options[:notification_url] || nil
      @sandbox_mode     = options[:sandbox] || false
      @api_version      = :v2
    end

    def api_url
      return MidtransApi::API_SANDBOX_URL if sandbox_mode

      MidtransApi::API_PRODUCTION_URL
    end
  end
end
