# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

require 'midtrans_api/api/base'
require 'midtrans_api/api/check/status'
require 'midtrans_api/api/bca_virtual_account/charge'
require 'midtrans_api/api/credit_card/charge'
require 'midtrans_api/api/credit_card/token'
require 'midtrans_api/api/gopay/charge'
require 'midtrans_api/api/transaction/expire'
require 'midtrans_api/api/transaction/charge'
require 'midtrans_api/api/check/balance'
require 'midtrans_api/api/disbursement/payout'
require 'midtrans_api/api/merchant/create'
require 'midtrans_api/api/channel/list'

require 'midtrans_api/middleware/handle_response_exception'
require 'midtrans_api/middleware/faraday_log_formatter'

require 'midtrans_api/model/base'
require 'midtrans_api/model/check/status'
require 'midtrans_api/model/bca_virtual_account/charge'
require 'midtrans_api/model/credit_card/charge'
require 'midtrans_api/model/credit_card/token'
require 'midtrans_api/model/gopay/charge'
require 'midtrans_api/model/transaction/expire'
require 'midtrans_api/model/transaction/charge'
require 'midtrans_api/model/check/balance'
require 'midtrans_api/model/disbursement/payout'
require 'midtrans_api/model/merchant/create'

module MidtransApi
  class Client
    attr_reader :config

    def initialize(options = {})
      @config = MidtransApi::Configure.new(options)

      yield @config if block_given?

      @connection = Faraday.new(url: "#{@config.api_url}/#{@config.api_version}/") do |connection|
        connection.request :basic_auth, @config.server_key, ''
        connection.options.timeout = @config.timeout

        unless @config.notification_url.nil?
          connection.headers['X-Override-Notification'] = @config.notification_url
        end

        connection.request :json
        connection.response :json

        connection.use MidtransApi::Middleware::HandleResponseException
        connection.adapter Faraday.default_adapter

        logger = find_logger(options[:logger])
        if logger
          connection.response :logger, logger,
                              full_hide_params: options[:filtered_logs] || [],
                              mask_params: options[:mask_params] || [],
                              formatter: MidtransApi::Middleware::FaradayLogFormatter
        end
      end
    end

    def bca_virtual_account_charge
      @charge ||= MidtransApi::Api::BcaVirtualAccount::Charge.new(self)
    end

    def expire_transaction
      @expire ||= MidtransApi::Api::Transaction::Expire.new(self)
    end

    def charge_transaction
      @charge ||= MidtransApi::Api::Transaction::Charge.new(self)
    end

    def gopay_charge
      @charge ||= MidtransApi::Api::Gopay::Charge.new(self)
    end

    def credit_card_token
      @credit_card_token ||= MidtransApi::Api::CreditCard::Token.new(self)
    end

    def credit_card_charge
      @credit_card_charge ||= MidtransApi::Api::CreditCard::Charge.new(self)
    end

    def status
      @status ||= MidtransApi::Api::Check::Status.new(self)
    end

    def balance
      @balance ||= MidtransApi::Api::Check::Balance.new(self)
    end

    def payout
      @payout ||= MidtransApi::Api::Disbursement::Payout.new(self)
    end

    def merchant
      @merchant ||= MidtransApi::Api::Merchant::Create.new(self)
    end

    def channel
      @channel ||= MidtransApi::Api::Channel::List.new(self)
    end

    def get(url, params, headers = {})
      response = @connection.get(url, params, headers)
      response.body
    end

    def post(url, params, headers = {})
      response = @connection.post(url, params, headers)
      response.body
    end

    private

    def find_logger(logger_options)
      logger_options || MidtransApi.configuration&.logger
    end
  end
end
