# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MidtransApi::Api::CreditCard::Token do
  let(:client) do
    MidtransApi::Client.new(client_key: 'client_key', server_key: 'server_key', midtrans_env: 'midtrans_env')
  end

  describe '#get' do
    context 'with valid params' do
      let(:params) do
        {
          client_key: client.config.client_key,
          currency: 'IDR',
          gross_amount: 10_000,
          card_number: 5_573_381_072_196_900,
          card_exp_month: 0o2,
          card_exp_year: 2025,
          card_cvv: 123
        }
      end

      let(:dummy_response) do
        {
          status_code: '200',
          status_message: 'Credit card token is created as Token ID.',
          token_id: 'redacted-token-id',
          hash: 'redacted-hash'
        }
      end

      it 'returns success response' do
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/token")
          .with(query: params)
          .to_return(status: 200, body: dummy_response.to_json)
        charge_api = described_class.new(client)
        response = charge_api.get(params)
        expect(response).to be_instance_of MidtransApi::Model::CreditCard::Token
        expect(response.status_code).to eq '200'
        expect(response.status_message).to eq 'Credit card token is created as Token ID.'
        expect(response.hash).to be_truthy
        expect(response.token_id).to be_truthy
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          client_key: client.config.client_key,
          currency: 'IDR',
          gross_amount: 10_000,
          card_number: 5_573_381_072_196_905,
          card_exp_month: 0o2,
          card_exp_year: 2025,
          card_cvv: 123
        }
      end

      let(:dummy_response) do
        {
          "status_code": '400',
          "status_message": 'One or more parameters in the payload is invalid.',
          "validation_messages": [
            'card_number does not match with luhn algorithm'
          ],
          "id": '669263b7-fbb4-412f-b913-8e1e84cf3dd3'
        }
      end

      it 'raise invalid parameters card number' do
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/token")
          .with(query: params)
          .to_return(status: 200, body: dummy_response.to_json)
        expect do
          charge_api = described_class.new(client)
          charge_api.get(params)
        end.to raise_error(MidtransApi::Errors::ValidationError, 'card_number does not match with luhn algorithm')
      end

      it 'raise invalid parameters secret/client key' do
        dummy_response = {
          "status_code": '401',
          "status_message": 'Transaction cannot be authorized with the current client/server key.',
          "id": '6fb3de50-8872-48a1-b798-073944609ffc'
        }
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/token")
          .with(query: params)
          .to_return(status: 200, body: dummy_response.to_json)
        expect do
          charge_api = described_class.new(client)
          charge_api.get(params)
        end.to raise_error(MidtransApi::Errors::AccessDenied, 'Transaction cannot be authorized with the current client/server key.')
      end
    end
  end
end
