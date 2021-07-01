# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MidtransApi::Errors do
  let(:client) do
    MidtransApi::Client.new(
      client_key: 'client_key',
      server_key: 'server_key',
      sandbox: true
    )
  end

  let(:dummy_response) do
    {
      "status_code": '999',
      "status_message": 'This is dummy status message of error code.',
      "id": '669263b7-fbb4-412f-b913-8e1e84cf3dd3'
    }
  end

  describe '#simulate' do
    context 'status code xxx' do
      it 'UnknownError' do
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/test")
          .to_return(status: 200, body: dummy_response.to_json)
        expect do
          client.get("#{client.config.api_url}/#{client.config.api_version}/test", {})
        end.to raise_error(MidtransApi::Errors::UnknownError, 'This is dummy status message of error code.')
      end
    end

    context 'status code 3xx' do
      it 'MovePermanently' do
        dummy_response[:status_code] = '300'
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/test")
          .to_return(status: 200, body: dummy_response.to_json)
        expect do
          client.get("#{client.config.api_url}/#{client.config.api_version}/test", {})
        end.to raise_error(MidtransApi::Errors::MovePermanently, 'This is dummy status message of error code.')
      end
    end

    context 'status code 4xx' do
      error_code = {
        '401': {
          'title': 'AccessDenied',
          'raises': MidtransApi::Errors::AccessDenied
        },
        '402': {
          'title': 'UnauthorizedPayment',
          'raises': MidtransApi::Errors::UnauthorizedPayment
        },
        '403': {
          'title': 'ForbiddenRequest',
          'raises': MidtransApi::Errors::ForbiddenRequest
        },
        '404': {
          'title': 'NotFound',
          'raises': MidtransApi::Errors::NotFound
        },
        '405': {
          'title': 'HttpNotAllowed',
          'raises': MidtransApi::Errors::HttpNotAllowed
        },
        '406': {
          'title': 'DuplicateOrderId',
          'raises': MidtransApi::Errors::DuplicateOrderId
        },
        '408': {
          'title': 'WrongDataType',
          'raises': MidtransApi::Errors::WrongDataType
        },
        '409': {
          'title': 'ManySameCardNumber',
          'raises': MidtransApi::Errors::ManySameCardNumber
        },
        '410': {
          'title': 'MerchantAccountDeactivated',
          'raises': MidtransApi::Errors::MerchantAccountDeactivated
        },
        '411': {
          'title': 'ErrorTokenId',
          'raises': MidtransApi::Errors::ErrorTokenId
        },
        '412': {
          'title': 'CannotModifyTransaction',
          'raises': MidtransApi::Errors::CannotModifyTransaction
        },
        '413': {
          'title': 'MalformedSyntax',
          'raises': MidtransApi::Errors::MalformedSyntax
        },
        '414': {
          'title': 'RefundInvalidAmount',
          'raises': MidtransApi::Errors::RefundInvalidAmount
        }
      }
      error_code.each do |code, data|
        it data[:title] do
          dummy_response[:status_code] = code
          stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/test")
            .to_return(status: 200, body: dummy_response.to_json)
          expect do
            client.get("#{client.config.api_url}/#{client.config.api_version}/test", {})
          end.to raise_error(data[:raises], 'This is dummy status message of error code.')
        end
      end
    end

    context 'status code 5xx' do
      error_code = {
        '500': {
          'title': 'InternalServerError',
          'raises': MidtransApi::Errors::InternalServerError
        },
        '501': {
          'title': 'FeatureNotAvailable',
          'raises': MidtransApi::Errors::FeatureNotAvailable
        },
        '502': {
          'title': 'BankConnectionProblem',
          'raises': MidtransApi::Errors::BankConnectionProblem
        },
        '503': {
          'title': 'PartnerConnectionIssue',
          'raises': MidtransApi::Errors::PartnerConnectionIssue
        },
        '504': {
          'title': 'FraudDetectionUnavailable',
          'raises': MidtransApi::Errors::FraudDetectionUnavailable
        },
        '505': {
          'title': 'PaymentReferenceUnavailable',
          'raises': MidtransApi::Errors::PaymentReferenceUnavailable
        }
      }
      error_code.each do |code, data|
        it data[:title] do
          dummy_response[:status_code] = code
          stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/test")
            .to_return(status: 200, body: dummy_response.to_json)
          expect do
            client.get("#{client.config.api_url}/#{client.config.api_version}/test", {})
          end.to raise_error(data[:raises], 'This is dummy status message of error code.')
        end
      end
    end
  end
end
