# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MidtransApi::Api::Transaction::Charge do
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
      "order_id": 'generated_by_you',
      "gross_amount": 60_000
    }
  end

  let(:dummy_item_details) do
    [
      {
        "id": 'subs package',
        "price": 60_000,
        "quantity": 1,
        "name": 'subs package premier league'
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

  let(:dummy_params_permata) do
    {
      "payment_type": 'bank_transfer',
      "transaction_details": dummy_transaction_details,
      "item_details": dummy_item_details,
      "customer_details": dummy_customer_details,
      "bank_transfer": {
        "bank": 'permata',
        "va_number": '111111'
      }
    }
  end

  let(:dummy_params_bni) do
    {
      "payment_type": 'bank_transfer',
      "transaction_details": {
        "order_id": 'generated_by_you',
        "gross_amount": 20_000
      },
      "bank_transfer": {
        "bank": 'bni',
        "va_number": '111111'
      }
    }
  end

  let(:dummy_params_bri) do
    {
      "payment_type": 'bank_transfer',
      "transaction_details": {
        "order_id": 'generated_by_you',
        "gross_amount": 20_000
      },
      "bank_transfer": {
        "bank": 'bri',
        "va_number": '111111'
      }
    }
  end

  let(:dummy_params_cimb) do
    {
      "payment_type": 'bank_transfer',
      "transaction_details": {
        "order_id": 'generated_by_you',
        "gross_amount": 20_000
      },
      "bank_transfer": {
        "bank": 'cimb',
        "va_number": '111111'
      }
    }
  end

  let(:dummy_params_mandiri_bill) do
    {
      "payment_type": "echannel",
      "transaction_details": {
          "order_id": "1388",
          "gross_amount": 95000
          },
      "item_details": [
          {
            "id": "a1",
            "price": 50000,
            "quantity": 2,
            "name": "Apel"
          },
          {
           "id": "a2",
            "price": 45000,
            "quantity": 1,
            "name": "Jeruk"
          }
      ],
      "echannel": {
        "bill_info1": "Payment For:",
        "bill_info2": "debt",
        "bill_key": "081211111111"
      }
    }
  end

  describe '#post' do
    context 'with valid params' do
      dummy_response_permata = {
        "status_code": "201",
        "status_message": "Success, PERMATA VA transaction is successful",
        "transaction_id": "6fd88567-62da-43ff-8fe6-5717e430ffc7",
        "order_id": "H17550",
        "gross_amount": "145000.00",
        "payment_type": "bank_transfer",
        "transaction_time": "2016-06-19 13:42:29",
        "transaction_status": "pending",
        "fraud_status": "accept",
        "permata_va_number": "8562000087926752",
        "expiry_time": "2017-01-09 09:56:44"
      }

      dummy_response_bni = {
        "status_code": "201",
        "status_message": "Success, Bank Transfer transaction is created",
        "transaction_id": "9aed5972-5b6a-401e-894b-a32c91ed1a3a",
        "order_id": "1466323342",
        "gross_amount": "20000.00",
        "payment_type": "bank_transfer",
        "transaction_time": "2016-06-19 15:02:22",
        "transaction_status": "pending",
        "va_numbers": [
          {
            "bank": "bni",
            "va_number": "8578000000111111"
          }
        ],
        "fraud_status": "accept",
        "currency": "IDR"
      }

      dummy_response_bri = {
        "status_code": "201",
        "status_message": "Success, Bank Transfer transaction is created",
        "transaction_id": "9aed5972-5b6a-401e-894b-a32c91ed1a3a",
        "order_id": "1466323342",
        "gross_amount": "20000.00",
        "payment_type": "bank_transfer",
        "transaction_time": "2016-06-19 15:02:22",
        "transaction_status": "pending",
        "va_numbers": [
          {
            "bank": "bri",
            "va_number": "8578000000111111"
          }
        ],
        "fraud_status": "accept",
        "currency": "IDR"
      }

      dummy_response_cimb = {
        "status_code": "201",
        "status_message": "Success, Bank Transfer transaction is created",
        "transaction_id": "9aed5972-5b6a-401e-894b-a32c91ed1a3a",
        "order_id": "1466323342",
        "gross_amount": "20000.00",
        "payment_type": "bank_transfer",
        "transaction_time": "2016-06-19 15:02:22",
        "transaction_status": "pending",
        "va_numbers": [
          {
            "bank": "cimb",
            "va_number": "8578000000111111"
          }
        ],
        "fraud_status": "accept",
        "currency": "IDR",
        "expiry_time": "2023-06-29 15:15:58"
      }

      dummy_response_mandiri_bill = {
        "status_code": "201",
        "status_message": "Success, Mandiri Bill transaction is successful",
        "transaction_id": "883af6a4-c1b4-4d39-9bd8-b148fcebe853",
        "order_id": "tes",
        "gross_amount": "1000.00",
        "payment_type": "echannel",
        "transaction_time": "2016-06-19 14:40:19",
        "transaction_status": "pending",
        "fraud_status": "accept",
        "bill_key": "990000000260",
        "biller_code": "70012",
        "currency": "IDR",
        "expiry_time": "2017-01-09 09:56:44"
      }

      it 'returns success response permata virtual account' do
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params_permata)
          .to_return(status: 200, body: dummy_response_permata.to_json)
        charge_api = described_class.new(client)
        response = charge_api.post(dummy_params_permata, "bank_transfer")
        expect(response).to be_instance_of MidtransApi::Model::Transaction::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '145000.00'
        expect(response.status_message).to eq 'Success, PERMATA VA transaction is successful'
        expect(response.transaction_status).to eq 'pending'
      end

      it 'returns success response bni virtual account' do
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params_bni)
          .to_return(status: 200, body: dummy_response_bni.to_json)
        charge_api = described_class.new(client)
        response = charge_api.post(dummy_params_bni, "bank_transfer")
        expect(response).to be_instance_of MidtransApi::Model::Transaction::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '20000.00'
        expect(response.status_message).to eq 'Success, Bank Transfer transaction is created'
        expect(response.transaction_status).to eq 'pending'
        expect(response.va_numbers).to be_truthy
      end

      it 'returns success response bri virtual account' do
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params_bri)
          .to_return(status: 200, body: dummy_response_bri.to_json)
        charge_api = described_class.new(client)
        response = charge_api.post(dummy_params_bri, "bank_transfer")
        expect(response).to be_instance_of MidtransApi::Model::Transaction::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '20000.00'
        expect(response.status_message).to eq 'Success, Bank Transfer transaction is created'
        expect(response.transaction_status).to eq 'pending'
        expect(response.va_numbers).to be_truthy
      end

      it 'returns success response cimb virtual account' do
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params_cimb)
          .to_return(status: 200, body: dummy_response_cimb.to_json)
        charge_api = described_class.new(client)
        response = charge_api.post(dummy_params_cimb, "bank_transfer")
        expect(response).to be_instance_of MidtransApi::Model::Transaction::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.gross_amount).to eq '20000.00'
        expect(response.status_message).to eq 'Success, Bank Transfer transaction is created'
        expect(response.transaction_status).to eq 'pending'
        expect(response.va_numbers).to be_truthy
      end

      it 'returns success response mandiri bill payment' do
        stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/charge")
          .with(body: dummy_params_mandiri_bill)
          .to_return(status: 200, body: dummy_response_mandiri_bill.to_json)
        charge_api = described_class.new(client)
        response = charge_api.post(dummy_params_mandiri_bill, "echannel")
        expect(response).to be_instance_of MidtransApi::Model::Transaction::Charge
        expect(response.transaction_time).to be_truthy
        expect(response.status_code).to eq '201'
        expect(response.status_message).to eq 'Success, Mandiri Bill transaction is successful'
        expect(response.gross_amount).to eq '1000.00'
        expect(response.biller_code).to eq '70012'
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
          .with(body: dummy_params_permata)
          .to_return(status: 400, body: dummy_response.to_json)
        expect do
          charge_api = described_class.new(client)
          charge_api.post(dummy_params_permata, "bank_transfer")
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
          .with(body: dummy_params_permata)
          .to_return(status: 406, body: dummy_response.to_json)
        expect do
          charge_api = described_class.new(client)
          charge_api.post(dummy_params_permata, "bank_transfer")
        end.to raise_error(MidtransApi::Errors::DuplicateOrderId,
                           'The request could not be completed due to a conflict with the current state of the target resource, please try again')
      end
    end
  end
end
