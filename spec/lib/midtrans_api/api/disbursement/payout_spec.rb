# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi::Api::Disbursement::Payout do
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
      payouts: [
        {
          "beneficiary_name": "Jon Snow",
          "beneficiary_account": "1172993826",
          "beneficiary_bank": "bni",
          "beneficiary_email": "beneficiary@example.com",
          "amount": "100000.00",
          "notes": "Payout April 17"
        },
        {
          "beneficiary_name": "John Doe",
          "beneficiary_account": "112673910288",
          "beneficiary_bank": "mandiri",
          "amount": "50000.00",
          "notes": "Payout May 17"
        }
      ]
    }
  end

  let(:success_response) do
    {
      "payouts": [
        {
          "status": "queued",
          "reference_no": "1d4f8423393005"
        },
        {
          "status": "queued",
          "reference_no": "10438f2b393005"
        }
      ]
    }
  end

  describe '#post' do
    it 'will returns expected response' do
      stub_request(:post, "#{client.config.api_url}/#{client.config.api_version}/payouts").to_return(
        status: 201, body: success_response.to_json
      )

      payouts_api = described_class.new(client)
      response = payouts_api.post(params)
      expect(response.payouts.to_json).to eq(success_response[:payouts].to_json)
    end
  end
end