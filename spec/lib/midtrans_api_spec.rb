# frozen_string_literal: true

require 'spec_helper'

describe MidtransApi do
  it 'set the api url' do
    expect(MidtransApi::API_PRODUCTION_URL).not_to be nil
    expect(MidtransApi::API_SANDBOX_URL).not_to be nil
  end
end
