# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MidtransApi::Api::CreditCard::Charge do
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
      "order_id": 'order-with-credit-card-online-installment',
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
      "payment_type": 'credit_card',
      "transaction_details": dummy_transaction_details,
      "item_details": dummy_item_details,
      "customer_details": dummy_customer_details,
      "credit_card": {
        "token_id": 'redacted-token-id',
        "authentication": true,
        "installment_term": 12,
        "bank": 'mandiri',
        "bins": [
          'mandiri'
        ]
      }
    }
  end

  describe '#post' do
    context 'with valid params online installment' do
      dummy_response = {
        "status_code": '201',
        "status_message": 'Success, Credit Card transaction is successful',
        "bank": 'mandiri',
        "transaction_id": 'redacted-transaction-id',
        "order_id": 'order-with-credit-card-online-installment',
        "redirect_url": 'https://api.sandbox.veritrans.co.id/v2/token/rba/redirect/redacted-token-rba-veritrans',
        "merchant_id": 'redacted-merchant-id',
        "gross_amount": '12500.00',
        "currency": 'IDR',
        "payment_type": 'credit_card',
        "transaction_time": '2020-09-28 14:50:42',
        "transaction_status": 'pending',
        "fraud_status": 'accept',
        "masked_card": '557338-6900',
        "card_type": 'credit',
        "installment_term": '12'
      }
      it 'using described class returns success response' do
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        charge_api = described_class.new(client)
        response = charge_api.post(dummy_params)
        expect(response).to be_instance_of MidtransApi::Model::CreditCard::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '12500.00'
        expect(response.transaction_status).to eq 'pending'
        expect(response.saved_token_id).to be_nil
        expect(response.redirect_url).to be_truthy
      end
    end

    context 'for recurring transaction' do
      dummy_response = {
        "status_code": '201',
        "status_message": 'Success, Credit Card transaction is successful',
        "bank": 'mandiri',
        "transaction_id": 'redacted-transaction-id',
        "order_id": 'order-with-credit-card-online-installment',
        "redirect_url": 'https://api.sandbox.veritrans.co.id/v2/token/rba/redirect/redacted-token-rba-veritrans',
        "merchant_id": 'redacted-merchant-id',
        "gross_amount": '12500.00',
        "currency": 'IDR',
        "payment_type": 'credit_card',
        "transaction_time": '2020-09-28 14:50:42',
        "transaction_status": 'pending',
        "fraud_status": 'accept',
        "masked_card": '557338-6900',
        "card_type": 'credit',
        "installment_term": '12',
        "saved_token_id": '481111xDUgxnnredRMAXuklkvAON1114',
        "saved_token_id_expired_at": '2020-12-31 07:00:00',
      }
      it 'using described class returns success response' do
        dummy_params[:save_token_id] = true

        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        charge_api = described_class.new(client)
        response = charge_api.post(dummy_params)
        expect(response).to be_instance_of MidtransApi::Model::CreditCard::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '12500.00'
        expect(response.transaction_status).to eq 'pending'
        expect(response.saved_token_id).to eq '481111xDUgxnnredRMAXuklkvAON1114'
        expect(response.saved_token_id_expired_at).to eq '2020-12-31 07:00:00'
        expect(response.redirect_url).to be_truthy
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
        end.to raise_error(MidtransApi::Errors::ValidationError, 'transaction_details.gross_amount is not equal to the sum of item_details')
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
        end.to raise_error(MidtransApi::Errors::DuplicateOrderId, 'The request could not be completed due to a conflict with the current state of the target resource, please try again')
      end

      it 'raise MalformedSyntax; invalid value of body like number send boolean' do
        dummy_response = {
          "status_code": '413',
          "status_message": 'Payload format is not supported.',
          "id": '033ff14a-a480-470e-8891-787aba65776f'
        }
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        expect do
          charge_api = described_class.new(client)
          charge_api.post(dummy_params)
        end.to raise_error(MidtransApi::Errors::MalformedSyntax, 'Payload format is not supported.')
      end
    end
  end
end
