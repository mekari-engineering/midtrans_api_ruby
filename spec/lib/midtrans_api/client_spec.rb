# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi::Client do
  describe '#initialize' do
    let(:params) do
      {
        client_key: 'client_key',
        server_key: 'server_key',
        sandbox: true,
        notification_url: 'notification_url'
      }
    end

    shared_examples 'set given params' do
      it do
        config = subject.instance_variable_get(:@config)
        expect(config.client_key).to        eq params[:client_key]
        expect(config.server_key).to        eq params[:server_key]
        expect(config.notification_url).to  eq params[:notification_url]
        expect(config.sandbox_mode).to      eq params[:sandbox]
      end
    end

    context 'midtrans sandbox' do
      it '#true' do
        client = described_class.new(
          client_key: 'client_key',
          server_key: 'server_key',
          sandbox: true
        )
        expect(client.config.api_url).to eq MidtransApi::API_SANDBOX_URL
      end

      it '#false' do
        client = described_class.new(
          client_key: 'client_key',
          server_key: 'server_key',
          sandbox: false
        )
        expect(client.config.api_url).to eq MidtransApi::API_PRODUCTION_URL
      end
    end

    context 'when pass the params' do
      subject do
        MidtransApi::Client.new(params)
      end

      it_behaves_like 'set given params'
    end

    context 'when pass the block' do
      subject do
        MidtransApi::Client.new do |client|
          client.client_key       = params[:client_key]
          client.server_key       = params[:server_key]
          client.notification_url = params[:notification_url]
          client.sandbox_mode     = params[:sandbox]
        end
      end

      it_behaves_like 'set given params'
    end
  end

  context 'client initialize' do
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
        "order_id": 'order-with-gopay',
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

    describe '#bca_virtual_account_charge' do
      it do
        expect(client.bca_virtual_account_charge).to be_instance_of MidtransApi::Api::BcaVirtualAccount::Charge
      end

      it do
        dummy_params = {
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
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        response = client.bca_virtual_account_charge.post(dummy_params)
        expect(response).to be_instance_of MidtransApi::Model::BcaVirtualAccount::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '12500.00'
        expect(response.va_numbers).to be_truthy
      end
    end

    describe '#gopay_charge' do
      it do
        expect(client.gopay_charge).to be_instance_of MidtransApi::Api::Gopay::Charge
      end

      it do
        dummy_params = {
          "payment_type": 'gopay',
          "transaction_details": dummy_transaction_details,
          "item_details": dummy_item_details,
          "customer_details": dummy_customer_details,
          "gopay": {
            "enable_callback": true,
            "callback_url": client.config.notification_url
          }
        }

        dummy_response = {
          "status_code": '201',
          "status_message": 'GO-PAY transaction is created',
          "transaction_id": 'redacted-transaction-id',
          "order_id": 'order-with-gopay',
          "merchant_id": 'redacted-merchant-id',
          "gross_amount": '12500.00',
          "currency": 'IDR',
          "payment_type": 'gopay',
          "transaction_time": '2020-09-24 14:36:02',
          "transaction_status": 'pending',
          "fraud_status": 'accept',
          "actions": [
            {
              "name": 'generate-qr-code',
              "method": 'GET',
              "url": 'https://api.sandbox.veritrans.co.id/'
            },
            {
              "name": 'deeplink-redirect',
              "method": 'GET',
              "url": 'https://simulator.sandbox.midtrans.com/'
            },
            {
              "name": 'get-status',
              "method": 'GET',
              "url": 'https://api.sandbox.veritrans.co.id/'
            },
            {
              "name": 'cancel',
              "method": 'POST',
              "url": 'https://api.sandbox.veritrans.co.id/'
            }
          ]
        }
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        response = client.gopay_charge.post(dummy_params)
        expect(response).to be_instance_of MidtransApi::Model::Gopay::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '12500.00'
        expect(response.actions).to be_truthy
      end
    end

    describe '#credit_card_token' do
      it do
        expect(client.credit_card_token).to be_instance_of MidtransApi::Api::CreditCard::Token
      end

      it do
        dummy_params = {
          client_key: client.config.client_key,
          currency: 'IDR',
          gross_amount: 10_000,
          card_number: 5_573_381_072_196_900,
          card_exp_month: 0o2,
          card_exp_year: 2025,
          card_cvv: 123
        }

        dummy_response = {
          status_code: '200',
          status_message: 'Credit card token is created as Token ID.',
          token_id: 'redacted-token-id',
          hash: 'redacted-hash'
        }
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/token")
          .with(query: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        response = client.credit_card_token.get(dummy_params)
        expect(response).to be_instance_of MidtransApi::Model::CreditCard::Token
        expect(response.status_code).to eq '200'
        expect(response.status_message).to eq 'Credit card token is created as Token ID.'
        expect(response.hash).to be_truthy
        expect(response.token_id).to be_truthy
      end
    end

    describe '#credit_card_charge' do
      it do
        expect(client.credit_card_charge).to be_instance_of MidtransApi::Api::CreditCard::Charge
      end

      it do
        dummy_params = {
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
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
        response = client.credit_card_charge.post(dummy_params)
        expect(response).to be_instance_of MidtransApi::Model::CreditCard::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '12500.00'
        expect(response.transaction_status).to eq 'pending'
        expect(response.redirect_url).to be_truthy
      end
    end

    describe '#status' do
      it do
        expect(client.status).to be_instance_of MidtransApi::Api::Check::Status
      end

      it do
        dummy_order_id = 'order-id-founded'
        dummy_response = {
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
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/#{dummy_order_id}/status")
          .to_return(status: 200, body: dummy_response.to_json)
        response = client.status.get(order_id: dummy_order_id)
        expect(response).to be_instance_of MidtransApi::Model::Check::Status
        expect(response.transaction_time).to be_truthy
        expect(response.gross_amount).to eq '800000.00'
        expect(response.status_message).to eq 'Success, transaction is found'
        expect(response.payment_type).to eq 'gopay'
      end
    end

    describe '#get' do
      let(:dummy_params) do
        {
          client_key: client.config.client_key,
          currency: 'IDR',
          gross_amount: 10_000,
          card_number: 554_433_221_112_345,
          card_exp_month: 0o2,
          card_exp_year: 2025,
          card_cvv: 123
        }
      end
      let(:dummy_response) do
        {
          'status_code' => '200',
          'status_message' => 'Credit card token is created as Token ID.',
          'token_id' => '557338-6900-e0b9145c-2706-48b2-840d-ae83d0a22c3d',
          'hash' => '557338-6900-mami'
        }
      end

      before do
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/token")
          .with(query: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
      end

      subject { client.get('/v2/token', dummy_params) }
      it { is_expected.to eq dummy_response }
    end

    describe '#post' do
      let(:dummy_params) { { payment_type: 'credit_card' } }
      let(:dummy_response) { { 'status_code' => '200' } }

      before do
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/404/status")
          .with(body: dummy_params)
          .to_return(status: 200, body: dummy_response.to_json)
      end

      subject { client.post("/#{client.config.api_version}/404/status", dummy_params) }
      it { is_expected.to eq dummy_response }
    end
  end
end
