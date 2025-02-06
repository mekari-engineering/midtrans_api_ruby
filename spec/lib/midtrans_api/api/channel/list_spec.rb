# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi::Api::Channel::List do
  let(:client) do
    MidtransApi::Client.new(
      client_key: 'secret_key',
      server_key: 'secret_key',
      sandbox: true,
      api_version: :v1
    )
  end

  let(:success_response) do
    [
      {
        "id":1,
        "virtual_account_type": "mandiri_bill_key",
        "virtual_account_number": "991385480006"
      },
      {
        "id":2,
        "virtual_account_type": "permata_virtual_account_number",
        "virtual_account_number": "8778003756104047"
      }
    ]    
  end

  describe '#get' do
    it 'returns expected response' do
      stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/channels").to_return(
        status: 200, body: success_response.to_json
      )

      api = described_class.new(client)
      response = api.get('partner_id', 'merchant_id')
      expect(response).to be_instance_of Array
    end
  end
end