# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MidtransApi::Api::Transaction::Expire do
  let(:client) do
    MidtransApi::Client.new(
      client_key: 'client_key',
      server_key: 'server_key',
      sandbox: true,
      notification_url: 'someapps://callback'
    )
  end

  describe '#post' do
    context 'with valid params' do
      dummy_response = {
        "status_code": "407",
        "status_message": "Success, transaction is expired",
        "transaction_id": "24dd3e24-2b1f-4e09-9176-f4a15df3c869",
        "order_id": "eb046679-285a-4136-8977-e4c429cc3254",
        "merchant_id": "M045108",
        "gross_amount": "1000000.00",
        "currency": "IDR",
        "payment_type": "bank_transfer",
        "transaction_time": "2023-03-15 15:19:23",
        "transaction_status": "expire",
        "fraud_status": "accept"
      }
      dummy_order_id = "eb046679-285a-4136-8977-e4c429cc3254"
      it 'using described class returns success response' do
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/#{dummy_order_id}/expire")
          .with(body: {})
          .to_return(status: 200, body: dummy_response.to_json)
        expire_api = described_class.new(client)
        response = expire_api.post(order_id: dummy_order_id)

        expect(response).to be_instance_of MidtransApi::Model::Transaction::Expire
        expect(response.order_id).to eq dummy_order_id
        expect(response.transaction_status).to eq "expire"
      end
    end

    context 'with invalid params' do
      it 'raise NotFound; invalid transaction_id' do
        dummy_response = {
          "status_code": '404',
          "status_message": 'Transaction doesn\'t exist.',
          "id": 'b19510c2-6ad3-4c5b-92bf-049cfd5846c9'
        }
        dummy_order_id = "eb046679-28512312323254"
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/#{dummy_order_id}/expire")
          .with(body: {})
          .to_return(status: 404, body: dummy_response.to_json)
        expect do
          expire_api = described_class.new(client)
          expire_api.post(order_id: dummy_order_id)
        end.to raise_error(MidtransApi::Errors::NotFound, 'Transaction doesn\'t exist.')
      end

      it 'raise CannotModifyTransaction; cannot modify transaction' do
        dummy_response = {
          "status_code": '412',
          "status_message": 'Transaction status cannot be updated.',
          "id": '95c25db5-08a4-4b3e-b7ce-8d56ebed1dac'
        }
        dummy_order_id = "2d44562e-6cb6-44f5-8cbd-751acb6e9cd2"
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/#{dummy_order_id}/expire")
          .with(body: {})
          .to_return(status: 412, body: dummy_response.to_json)
        expect do
          expire_api = described_class.new(client)
          expire_api.post(order_id: dummy_order_id)
        end.to raise_error(MidtransApi::Errors::CannotModifyTransaction, 'Transaction status cannot be updated.')
      end
    end
  end
end
