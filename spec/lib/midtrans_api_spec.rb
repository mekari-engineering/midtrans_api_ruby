# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi do
  it 'set the api url' do
    expect(MidtransApi::API_PRODUCTION_URL).not_to be nil
    expect(MidtransApi::API_SANDBOX_URL).not_to be nil
  end

  describe '#configure' do
    after do
      # clening up cache test data
      described_class.configure do |config|
        config.logger = nil
      end
    end

    it 'returns expected custom logger' do
      custom_logger = Class.new(Object)
      described_class.configure do |config|
        config.logger = custom_logger
      end
      expect(described_class.configuration.logger).to eq custom_logger
    end
  end
end
