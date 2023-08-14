# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi::Api::Check::Status do
  let(:client) do
    MidtransApi::Client.new(
      client_key: 'client_key',
      server_key: 'server_key',
      sandbox: true
    )
  end

  let(:dummy_response) do
    {
      "transaction_time": '2020-09-24 11:29:57',
      "gross_amount": '800000.00',
      "currency": 'IDR',
      "order_id": 'order-id-founded',
      "payment_type": 'gopay',
      "signature_key": 'redacted-signature-key',
      "status_code": '407',
      "transaction_id": 'redacted-transaction-id',
      "transaction_status": 'expire',
      "fraud_status": 'accept',
      "status_message": 'Success, transaction is found',
      "merchant_id": 'redacted-merchant-id'
    }
  end

  let(:dummy_response_202) do
    {
      "masked_card": '471111-1115',
      "bank": 'cimb',
      "channel_response_code": '05',
      "channel_response_message": 'Do not honour',
      "transaction_time": '2021-06-30 18:07:31',
      "gross_amount": '500000.00',
      "currency": 'IDR',
      "order_id": 'a0cabb9b-b8f5-4f08-a66a-c52ed55c50ac',
      "payment_type": 'credit_card',
      "signature_key": '9b0802af53517e395935969084e1d40f29068bfe1ab03d4c693b8022c0074a7c85deafdc41223328721eb476d47680050fcc1d4c556434fbd89e34d9a12fbae7',
      "status_code": '202',
      "transaction_id": '6011bfc5-aeef-4268-a0d3-3e14161729cf',
      "transaction_status": 'deny',
      "fraud_status": 'accept',
      "status_message": 'Success, transaction is found',
      "merchant_id": 'M045108',
      "card_type": 'credit'
    }
  end

  let(:dummy_response_error) do
    {
      "status_code": '404',
      "status_message": "Transaction doesn't exist.",
      "id": 'redacted-id'
    }
  end

  describe '#get' do
    context 'when payment is exist' do
      it 'using described class returns expected response' do
        dummy_order_id = 'order-id-founded'
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/#{dummy_order_id}/status").to_return(
          status: 200, body: dummy_response.to_json
        )
        status_api = described_class.new(client)
        response = status_api.get(order_id: dummy_order_id)
        expect(response).to be_instance_of MidtransApi::Model::Check::Status
        expect(response.transaction_time).to be_truthy
        expect(response.gross_amount).to eq '800000.00'
        expect(response.status_message).to eq 'Success, transaction is found'
        expect(response.payment_type).to eq 'gopay'
      end

      it 'returns expected response when status code is 202' do
        dummy_order_id = 'a0cabb9b-b8f5-4f08-a66a-c52ed55c50ac'
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/#{dummy_order_id}/status").to_return(
          status: 200, body: dummy_response_202.to_json
        )
        status_api = described_class.new(client)
        response = status_api.get(order_id: 'a0cabb9b-b8f5-4f08-a66a-c52ed55c50ac')
        expect(response).to be_instance_of MidtransApi::Model::Check::Status
        expect(response.transaction_time).to be_truthy
        expect(response.gross_amount).to eq '500000.00'
        expect(response.status_message).to eq 'Success, transaction is found'
        expect(response.payment_type).to eq 'credit_card'
      end
    end

    context 'when payment not found' do
      dummy_order_id = 'not-found-order-id'
      before do
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/#{dummy_order_id}/status")
          .to_return(status: 404, body: dummy_response_error.to_json)
      end

      it 'returns error response' do
        expect do
          status_api = described_class.new(client)
          status_api.get(order_id: dummy_order_id)
        end.to raise_error(MidtransApi::Errors::NotFound, "Transaction doesn\'t exist.")
      end
    end
  end
  # TODO: add more cases
end
