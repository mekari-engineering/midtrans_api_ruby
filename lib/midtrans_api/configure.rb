# frozen_string_literal: true

module MidtransApi
  class Configure
    attr_accessor :client_key,
                  :server_key,
                  :notification_url,
                  :sandbox_mode,
                  :logger,
                  :timeout,
                  :log_headers
    attr_reader   :api_version

    def initialize(options = {})
      @client_key       = options[:client_key]
      @server_key       = options[:server_key]
      @notification_url = options[:notification_url] || nil
      @sandbox_mode     = options[:sandbox] || false
      @timeout          = options[:timeout] || 60
      @api_version      = options[:api_version] || :v2
      @use_partner_api  = options[:use_partner_api] || false
      @log_headers     = options[:log_headers] || false
    end

    def api_url
      return MidtransApi::API_PARTNER_URL if @use_partner_api

      return MidtransApi::API_SANDBOX_URL if sandbox_mode

      MidtransApi::API_PRODUCTION_URL
    end
  end
end
