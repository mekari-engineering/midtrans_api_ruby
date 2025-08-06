# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi::Api::Merchant::Get do
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
      "status_code": "200",
      "status_message": "Merchants have been successfully retrieved.",
      "merchants": [
        {
          "merchant_id": "G221991147",
          "merchant_name": "MSN KAP Agus Ubaidillah dan Rekan01",
          "merchant_phone_number": "+621000000000",
          "email": "dhany+39457_79@mekari.com"
        },
        {
          "merchant_id": "G539217527",
          "merchant_name": "MSN KAP Agus Ubaidillah dan Rekan01",
          "merchant_phone_number": "+621000000000",
          "email": "dhany+39457_80@mekari.com"
        }
      ]
    }
  end

  let(:empty_merchants_response) do
    {
      "status_code": "200",
      "status_message": "No merchants found.",
      "merchants": []
    }
  end

  let(:missing_merchants_response) do
    {
      "status_code": "200",
      "status_message": "No merchants found."
    }
  end

  let(:merchants_with_empty_fields_response) do
    {
      "status_code": "200",
      "status_message": "Merchants have been successfully retrieved.",
      "merchants": [
        {
          "merchant_id": "G221991147",
          "merchant_name": "",
          "merchant_phone_number": nil,
          "email": "dhany+39457_79@mekari.com"
        },
        {
          "merchant_id": "",
          "merchant_name": "Test Merchant",
          "merchant_phone_number": "+621000000000",
          "email": ""
        }
      ]
    }
  end

  let(:merchants_with_missing_fields_response) do
    {
      "status_code": "200",
      "status_message": "Merchants have been successfully retrieved.",
      "merchants": [
        {
          "merchant_id": "G221991147",
          "email": "dhany+39457_79@mekari.com"
        },
        {
          "merchant_name": "Test Merchant",
          "merchant_phone_number": "+621000000000"
        }
      ]
    }
  end

  describe '#get' do
    context 'with keyword parameter' do
      it 'returns expected response' do
        partner_id = '739'
        params = { keyword: 'MSN KAP Agus Ubaidillah dan Rekan01' }
        
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/merchants")
          .with(query: params)
          .to_return(status: 200, body: success_response.to_json)

        merchant_api = described_class.new(client)
        response = merchant_api.get(params, partner_id)
        
        expect(response).to be_instance_of MidtransApi::Model::Merchant::Get
        expect(response.merchants).to be_an(Array)
        expect(response.merchants.length).to eq(2)
        
        # Test merchant_list method
        merchant_list = response.merchant_list
        expect(merchant_list).to be_an(Array)
        expect(merchant_list.length).to eq(2)
        
        first_merchant = merchant_list.first
        expect(first_merchant.merchant_id).to eq('G221991147')
        expect(first_merchant.merchant_name).to eq('MSN KAP Agus Ubaidillah dan Rekan01')
        expect(first_merchant.merchant_phone_number).to eq('+621000000000')
        expect(first_merchant.email).to eq('dhany+39457_79@mekari.com')
      end
    end

    context 'without keyword parameter' do
      it 'returns expected response' do
        partner_id = '739'
        params = {}
        
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/merchants")
          .to_return(status: 200, body: success_response.to_json)

        merchant_api = described_class.new(client)
        response = merchant_api.get(params, partner_id)
        
        expect(response).to be_instance_of MidtransApi::Model::Merchant::Get
        expect(response.merchants).to be_an(Array)
      end
    end

    context 'when merchants array is empty' do
      it 'returns empty merchant list' do
        partner_id = '739'
        params = {}
        
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/merchants")
          .to_return(status: 200, body: empty_merchants_response.to_json)

        merchant_api = described_class.new(client)
        response = merchant_api.get(params, partner_id)
        
        expect(response).to be_instance_of MidtransApi::Model::Merchant::Get
        expect(response.merchants).to be_an(Array)
        expect(response.merchants).to be_empty
        expect(response.merchant_list).to be_an(Array)
        expect(response.merchant_list).to be_empty
      end
    end

    context 'when merchants field is missing from response' do
      it 'handles missing merchants field gracefully' do
        partner_id = '739'
        params = {}
        
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/merchants")
          .to_return(status: 200, body: missing_merchants_response.to_json)

        merchant_api = described_class.new(client)
        response = merchant_api.get(params, partner_id)
        
        expect(response).to be_instance_of MidtransApi::Model::Merchant::Get
        expect(response.merchants).to be_nil
        expect(response.merchant_list).to be_an(Array)
        expect(response.merchant_list).to be_empty
      end
    end

    context 'when merchant fields are empty or nil' do
      it 'handles empty and nil field values gracefully' do
        partner_id = '739'
        params = {}
        
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/merchants")
          .to_return(status: 200, body: merchants_with_empty_fields_response.to_json)

        merchant_api = described_class.new(client)
        response = merchant_api.get(params, partner_id)
        
        expect(response).to be_instance_of MidtransApi::Model::Merchant::Get
        expect(response.merchants).to be_an(Array)
        expect(response.merchants.length).to eq(2)
        
        merchant_list = response.merchant_list
        expect(merchant_list.length).to eq(2)
        
        first_merchant = merchant_list.first
        expect(first_merchant.merchant_id).to eq('G221991147')
        expect(first_merchant.merchant_name).to eq('')
        expect(first_merchant.merchant_phone_number).to be_nil
        expect(first_merchant.email).to eq('dhany+39457_79@mekari.com')
        
        second_merchant = merchant_list.last
        expect(second_merchant.merchant_id).to eq('')
        expect(second_merchant.merchant_name).to eq('Test Merchant')
        expect(second_merchant.merchant_phone_number).to eq('+621000000000')
        expect(second_merchant.email).to eq('')
      end
    end

    context 'when merchant fields are missing' do
      it 'handles missing field values gracefully' do
        partner_id = '739'
        params = {}
        
        stub_request(:get, "#{client.config.api_url}/#{client.config.api_version}/merchants")
          .to_return(status: 200, body: merchants_with_missing_fields_response.to_json)

        merchant_api = described_class.new(client)
        response = merchant_api.get(params, partner_id)
        
        expect(response).to be_instance_of MidtransApi::Model::Merchant::Get
        expect(response.merchants).to be_an(Array)
        expect(response.merchants.length).to eq(2)
        
        merchant_list = response.merchant_list
        expect(merchant_list.length).to eq(2)
        
        first_merchant = merchant_list.first
        expect(first_merchant.merchant_id).to eq('G221991147')
        expect(first_merchant.merchant_name).to be_nil
        expect(first_merchant.merchant_phone_number).to be_nil
        expect(first_merchant.email).to eq('dhany+39457_79@mekari.com')
        
        second_merchant = merchant_list.last
        expect(second_merchant.merchant_id).to be_nil
        expect(second_merchant.merchant_name).to eq('Test Merchant')
        expect(second_merchant.merchant_phone_number).to eq('+621000000000')
        expect(second_merchant.email).to be_nil
      end
    end
  end
end
