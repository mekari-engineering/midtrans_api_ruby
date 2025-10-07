# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi::Api::Merchant::UpdateNotification do
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
      "payment_notification_url": "https://merchant.com/midtrans-payment-notification",
      "iris_notification_url": "https://merchant.com/midtrans-payout-notification",
      "recurring_notification_url": "https://merchant.com/midtrans-recurring-notification",
      "pay_account_notification_url": "https://merchant.com/midtrans-pay-account-notification",
      "finish_payment_redirect_url": "https://merchant.com/payment-finish"
    }
  end

  let(:success_response) do
    {
      "status_code": "200",
      "status_message": "Notification URLs updated successfully",
      "payment_notification_url": "https://merchant.com/midtrans-payment-notification",
      "iris_notification_url": "https://merchant.com/midtrans-payout-notification",
      "recurring_notification_url": "https://merchant.com/midtrans-recurring-notification",
      "pay_account_notification_url": "https://merchant.com/midtrans-pay-account-notification",
      "finish_payment_redirect_url": "https://merchant.com/payment-finish"
    }
  end

  describe '#patch' do
    it 'returns expected response' do
      stub_request(:patch, "#{client.config.api_url}/#{client.config.api_version}/merchants/notifications").to_return(
        status: 200, body: success_response.to_json
      )

      update_notification_api = described_class.new(client)
      response = update_notification_api.patch(params, 'partner_id', 'merchant_id')
      expect(response).to be_instance_of MidtransApi::Model::Merchant::UpdateNotification
      expect(response.status_code).to eq(success_response[:status_code])
      expect(response.payment_notification_url).to eq(success_response[:payment_notification_url])
      expect(response.iris_notification_url).to eq(success_response[:iris_notification_url])
    end

    it 'sends required headers' do
      request = stub_request(:patch, "#{client.config.api_url}/#{client.config.api_version}/merchants/notifications")
        .with(
          headers: {
            'X-PARTNER-ID': 'test_partner_id',
            'X-MERCHANT-ID': 'test_merchant_id'
          }
        )
        .to_return(status: 200, body: success_response.to_json)

      update_notification_api = described_class.new(client)
      update_notification_api.patch(params, 'test_partner_id', 'test_merchant_id')

      expect(request).to have_been_requested
    end
  end
end
