require 'faraday/logging/formatter'
require 'midtrans_api/json_masker'
require 'midtrans_api/url_masker'

module MidtransApi
  module Middleware
    class FaradayLogFormatter < Faraday::Logging::Formatter
      MAX_LOG_SIZE = 10_000

      def initialize(env = {})
        @logger = env[:logger]
        @options = env[:options]
        super(logger: env[:logger], options: env[:options])
      end

      def request(env)
        masked_url = MidtransApi::UrlMasker.mask(env[:url].to_s, @options)
        @logger.info "#{env[:method].upcase} #{masked_url}"
        return if env[:request_body].to_s.empty?
        return if env[:request_body].to_s.size > MAX_LOG_SIZE

        message = {
          body: MidtransApi::JsonMasker.mask(env[:request_body], @options)
        }
        @logger.info({ request: message }.to_json)
      end

      def response(env)
        return if env[:response_body].to_s.empty?
        return if env[:request_body].to_s.size > MAX_LOG_SIZE

        message = {
          status: env[:status],
          body: MidtransApi::JsonMasker.mask(env[:response_body], @options)
        }
        @logger.info({ response: message }.to_json)
      end

      def exception(exc); end
    end
  end
end
