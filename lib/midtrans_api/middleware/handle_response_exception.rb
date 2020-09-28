# frozen_string_literal: true

module MidtransApi
  module Middleware
    class HandleResponseException < Faraday::Middleware
      VALID_STATUSES = %w[200 201 407].freeze

      def initialize(app)
        super(app)
      end

      def call(env)
        @app.call(env).on_complete do |response|
          validate_response(response.body)
        end
      end

      private

      # rubocop:disable Metrics/CyclomaticComplexity
      def validate_response(response)
        json_response = JSON.parse(response)
        return true if VALID_STATUSES.include?(json_response['status_code'])

        case json_response['status_code']
        when '202'
          raise MidtransApi::Errors::PaymentDenied, json_response['status_message']
        when '300'
          raise MidtransApi::Errors::MovePermanently, json_response['status_message']
        when '400'
          raise MidtransApi::Errors::ValidationError, json_response['validation_messages'].first
        when '401'
          raise MidtransApi::Errors::AccessDenied, json_response['status_message']
        when '402'
          raise MidtransApi::Errors::UnauthorizedPayment, json_response['status_message']
        when '403'
          raise MidtransApi::Errors::ForbiddenRequest, json_response['status_message']
        when '404'
          raise MidtransApi::Errors::NotFound, json_response['status_message']
        when '405'
          raise MidtransApi::Errors::HttpNotAllowed, json_response['status_message']
        when '406'
          raise MidtransApi::Errors::DuplicateOrderId, json_response['status_message']
        when '408'
          raise MidtransApi::Errors::WrongDataType, json_response['status_message']
        when '409'
          raise MidtransApi::Errors::ManySameCardNumber, json_response['status_message']
        when '410'
          raise MidtransApi::Errors::MerchantAccountDeactivated, json_response['status_message']
        when '411'
          raise MidtransApi::Errors::ErrorTokenId, json_response['status_message']
        when '412'
          raise MidtransApi::Errors::CannotModifyTransaction, json_response['status_message']
        when '413'
          raise MidtransApi::Errors::MalformedSyntax, json_response['status_message']
        when '414'
          raise MidtransApi::Errors::RefundInvalidAmount, json_response['status_message']
        when '500'
          raise MidtransApi::Errors::InternalServerError, json_response['status_message']
        when '501'
          raise MidtransApi::Errors::FeatureNotAvailable, json_response['status_message']
        when '502'
          raise MidtransApi::Errors::BankConnectionProblem, json_response['status_message']
        when '503'
          raise MidtransApi::Errors::PartnerConnectionIssue, json_response['status_message']
        when '504'
          raise MidtransApi::Errors::FraudDetectionUnavailable, json_response['status_message']
        when '505'
          raise MidtransApi::Errors::PaymentReferenceUnvailable, json_response['status_message']
        else
          raise MidtransApi::Errors::UnknownError, json_response['status_message']
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
    end
  end
end
