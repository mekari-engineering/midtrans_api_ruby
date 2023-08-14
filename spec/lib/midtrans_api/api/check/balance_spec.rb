# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi::Api::Check::Balance do
  let(:client) do
    MidtransApi::Client.new(
      client_key: 'secret_key',
      server_key: 'secret_key',
      sandbox: true,
      api_version: :v1
    )
  end

  let(:success_response) do
    {
      "balance": "25000.00"
    }
  end

  describe '#get' do
    it 'will returns expected response' do
      stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/balance").to_return(
        status: 200, body: success_response.to_json
      )

      check_balance_api = described_class.new(client)
      response = check_balance_api.get
      expect(response.balance).to eq(success_response[:balance])
    end
  end
end