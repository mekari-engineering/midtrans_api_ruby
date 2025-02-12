# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi::Api::Merchant::Create do
  let(:client) do
    MidtransApi::Client.new(
      client_key: 'secret_key',
      server_key: 'secret_key',
      sandbox: true,
      api_version: :v1
    )
  end

  let(:params) do
    {
      "email": "merchant@midtrans.com",
      "merchant_name": "HQ Midtrans Merchant",
      "callback_url": "https://merchant.com/midtrans-callback",
      "notification_url": "https://merchant.com/midtrans-notification",
      "pay_account_url": "https://merchant.com/pay-account-notification",
      "owner_name": "Owner Midtrans",
      "merchant_phone_number": "81211111111",
      "mcc": "Event",
      "entity_type": "corporate",
      "business_name": "PT Business Name"
    }
  end

  let(:success_response) do
    {
      "status_code": "200",
      "status_message": "Merchants have been successfully created.",
      "merchant_id": "M123456",
      "merchant_name": "HQ Midtrans Merchant",
      "merchant_phone_number": "81211111111",
      "email": "merchant@midtrans.com",
      "callback_url": "https://merchant.com/midtrans-callback",
      "notification_url": "https://merchant.com/midtrans-notification",
      "pay_account_url": "https://merchant.com/pay-account-notification",
      "owner_name": "Owner Midtrans",
      "mcc": "Event",
      "entity_type": "corporate",
      "business_name": "business name"
    }
  end

  describe '#post' do
    it 'returns expected response' do
      stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/merchants").to_return(
        status: 200, body: success_response.to_json
      )

      payouts_api = described_class.new(client)
      response = payouts_api.post(params, 'partner_id')
      expect(response).to be_instance_of MidtransApi::Model::Merchant::Create
      expect(response.email).to eq(success_response[:email])
    end
  end
end
