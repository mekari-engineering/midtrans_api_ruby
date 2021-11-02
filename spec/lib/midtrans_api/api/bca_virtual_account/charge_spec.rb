# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MidtransApi::Api::BcaVirtualAccount::Charge do
  let(:client) do
    MidtransApi::Client.new(
      client_key: 'client_key',
      server_key: 'server_key',
      sandbox: true,
      notification_url: 'someapps://callback'
    )
  end

  let(:dummy_transaction_details) do
    {
      "order_id": 'order-with-bca-virtual-account',
      "gross_amount": 12_500
    }
  end

  let(:dummy_item_details) do
    [
      {
        "id": 'bluedio-turbine',
        "price": 12_500,
        "quantity": 1,
        "name": 'Bluedio H+ Turbine Headphone with Bluetooth 4.1 -'
      }
    ]
  end

  let(:dummy_customer_details) do
    {
      "first_name": 'Budi',
      "last_name": 'Utomo',
      "email": 'budi.utomo@midtrans.com',
      "phone": '081223323423'
    }
  end

  let(:dummy_params) do
    {
      "payment_type": 'bank_transfer',
      "transaction_details": dummy_transaction_details,
      "item_details": dummy_item_details,
      "customer_details": dummy_customer_details,
      "bank_transfer": {
        "bank": 'bca',
        "va_number": '111111',
        "free_text": {
          "inquiry": [
            {
              "id": 'Free Text ID',
              "en": 'Free Text EN'
            }
          ],
          "payment": [
            {
              "id": 'Free Text ID',
              "en": 'Free Text EN'
            }
          ]
        }
      },
      "bca": {
        "sub_company_code": '0000'
      }
    }
  end

  describe '#post' do
    context 'with valid params' do
      dummy_response = {
        "status_code": '201',
        "status_message": 'Success, Bank Transfer transaction is created',
        "transaction_id": 'redacted-transaction-id',
        "order_id": 'order-with-bca-virtual-account',
        "merchant_id": 'redacted-merchant-id',
        "gross_amount": '12500.00',
        "payment_type": 'bank_transfer',
        "transaction_time": '2020-09-24 14:36:02',
        "transaction_status": 'pending',
        "va_numbers": [
          {
            "bank": 'bca',
            "va_number": '12345678900'
          }
        ],
        "fraud_status": 'accept',
        "currency": 'IDR'
      }
      it 'using described class returns success response' do
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        charge_api = described_class.new(client)
        response = charge_api.post(dummy_params)
        expect(response).to be_instance_of MidtransApi::Model::BcaVirtualAccount::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '12500.00'
        expect(response.va_numbers).to be_truthy
      end
    end

    context 'with invalid params' do
      it 'raise ValidationError; gross amount not equal to the sum of item details' do
        dummy_transaction_details[:gross_amount] = 50_000
        dummy_response = {
          "status_code": '400',
          "status_message": 'One or more parameters in the payload is invalid.',
          "validation_messages": [
            'transaction_details.gross_amount is not equal to the sum of item_details'
          ],
          "id": '571936a7-15c9-48b3-9ae2-9c53d05b07df'
        }
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        expect do
          charge_api = described_class.new(client)
          charge_api.post(dummy_params)
        end.to raise_error(MidtransApi::Errors::ValidationError,
                           'transaction_details.gross_amount is not equal to the sum of item_details')
      end

      it 'raise DuplicateOrderId; conflict order id' do
        dummy_response = {
          "status_code": '406',
          "status_message": 'The request could not be completed due to a conflict with the current state of the target resource, please try again',
          "id": '912fed6d-230e-410e-a002-d3e4cdf07789'
        }
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        expect do
          charge_api = described_class.new(client)
          charge_api.post(dummy_params)
        end.to raise_error(MidtransApi::Errors::DuplicateOrderId,
                           'The request could not be completed due to a conflict with the current state of the target resource, please try again')
      end
    end
  end
end
