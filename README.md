# Midtrans API Ruby Client

A Ruby client library for the [Midtrans Payment Gateway API](https://api-docs.midtrans.com/). This gem provides a clean and intuitive interface to interact with Midtrans services including payment transactions, virtual accounts, disbursements, and merchant management.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Credit Card Payments](#credit-card-payments)
  - [GoPay Payments](#gopay-payments)
  - [Bank Transfer / Virtual Account](#bank-transfer--virtual-account)
  - [Transaction Management](#transaction-management)
  - [Merchant Management](#merchant-management)
  - [Disbursements](#disbursements)
  - [Utilities](#utilities)
- [Error Handling](#error-handling)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mekari-midtrans-api'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install mekari-midtrans-api
```

## Configuration

### Basic Configuration
```ruby
require 'midtrans_api'

midtrans = MidtransApi::Client.new(
  client_key: 'YOUR-CLIENT-KEY',
  server_key: 'YOUR-SERVER-KEY',
  sandbox: true,  # Set to false for production
  timeout: 30     # Optional, default is 60 seconds
)

# Using block initialization
midtrans = MidtransApi::Client.new do |config|
  config.client_key = 'YOUR-CLIENT-KEY'
  config.server_key = 'YOUR-SERVER-KEY'
  config.sandbox_mode = true
end
```

### Advanced Configuration

```ruby
midtrans = MidtransApi::Client.new(
  client_key: 'YOUR-CLIENT-KEY',
  server_key: 'YOUR-SERVER-KEY',
  sandbox: false,
  notification_url: 'https://example.com/callback',  # Override notification URL
  logger: Logger.new(STDOUT),                        # Enable logging
  filtered_logs: %w[card_number card_cvv],           # Filter sensitive data from logs
  mask_params: %w[token_id],                         # Mask specific parameters
  timeout: 30                                         # Request timeout in seconds
)
```

## Usage

### Credit Card Payments

#### Get Credit Card Token
```ruby
credit_card_params = {
  currency: 'IDR',
  gross_amount: 12500,
  card_number: 5573381072196900,
  card_exp_month: 2,
  card_exp_year: 2025,
  card_cvv: 123
}

token = midtrans.credit_card_token.get(credit_card_params)
# Returns: MidtransApi::Model::CreditCard::Token
```

#### Charge with Installment

```ruby
charge_params = {
  payment_type: 'credit_card',
  transaction_details: {
    order_id: 'order-101',
    gross_amount: 12500
  },
  credit_card: {
    token_id: token.token_id,
    authentication: true,
    installment_term: 3,
    bank: 'mandiri'
  },
  customer_details: {
    first_name: 'Budi',
    last_name: 'Utomo',
    email: 'test@midtrans.com',
    phone: '081111333344'
  },
  item_details: [
    {
      id: 'invoice-1',
      price: 12500,
      quantity: 1,
      name: 'Invoice #1'
    }
  ]
}

charge = midtrans.credit_card_charge.post(charge_params)
# Returns: MidtransApi::Model::CreditCard::Charge
```

### GoPay Payments

```ruby
charge_params = {
  payment_type: 'gopay',
  transaction_details: {
    order_id: 'order-102',
    gross_amount: 12500
  },
  item_details: [
    {
      id: 'item-1',
      price: 12500,
      quantity: 1,
      name: 'Product Name'
    }
  ],
  customer_details: {
    first_name: 'Budi',
    last_name: 'Utomo',
    email: 'budi.utomo@midtrans.com',
    phone: '081223323423'
  },
  gopay: {
    enable_callback: true,
    callback_url: 'someapps://callback'
  }
}

charge = midtrans.gopay_charge.post(charge_params)
# Returns: MidtransApi::Model::Gopay::Charge
```

### Bank Transfer / Virtual Account

#### BCA Virtual Account

```ruby
charge_params = {
  payment_type: 'bank_transfer',
  transaction_details: {
    order_id: 'order-103',
    gross_amount: 12500
  },
  item_details: [
    {
      id: 'item-1',
      price: 12500,
      quantity: 1,
      name: 'Product Name'
    }
  ],
  customer_details: {
    first_name: 'Budi',
    last_name: 'Utomo',
    email: 'budi.utomo@midtrans.com',
    phone: '081223323423'
  },
  bank_transfer: {
    bank: 'bca',
    va_number: '11111111',
    free_text: {
      inquiry: [{ id: 'Free Text Inquiry ID', en: 'Free Text Inquiry EN' }],
      payment: [{ id: 'Free Text Payment ID', en: 'Free Text Payment EN' }]
    }
  },
  bca: {
    sub_company_code: '000'
  }
}

charge = midtrans.bca_virtual_account_charge.post(charge_params)
# Returns: MidtransApi::Model::BcaVirtualAccount::Charge
```

#### Other Bank Virtual Accounts

Supported banks: Permata, BNI, BRI, CIMB

```ruby
charge_params = {
  payment_type: 'bank_transfer',
  transaction_details: {
    gross_amount: 10000,
    order_id: 'order-104'
  },
  customer_details: {
    email: 'budi.utomo@midtrans.com',
    first_name: 'Budi',
    last_name: 'Utomo',
    phone: '+6281 1234 1234'
  },
  item_details: [
    {
      id: '1388998298204',
      price: 5000,
      quantity: 1,
      name: 'Item A'
    },
    {
      id: '1388998298205',
      price: 5000,
      quantity: 1,
      name: 'Item B'
    }
  ],
  bank_transfer: {
    bank: 'bni',  # Options: bni, bri, permata, cimb
    va_number: '111111'
  }
}

charge = midtrans.charge_transaction.post(charge_params, 'bank_transfer')
# Returns: MidtransApi::Model::Transaction::Charge
```

#### Mandiri Bill Payment (E-Channel)

```ruby
charge_params = {
  payment_type: 'echannel',
  transaction_details: {
    order_id: 'order-105',
    gross_amount: 95000
  },
  item_details: [
    {
      id: 'a1',
      price: 50000,
      quantity: 2,
      name: 'Apel'
    },
    {
      id: 'a2',
      price: 45000,
      quantity: 1,
      name: 'Jeruk'
    }
  ],
  echannel: {
    bill_info1: 'Payment For:',
    bill_info2: 'Debt',
    bill_key: '081211111111'
  }
}

charge = midtrans.charge_transaction.post(charge_params, 'echannel')
# Returns: MidtransApi::Model::Transaction::Charge
```

### Transaction Management

#### Check Transaction Status

```ruby
status = midtrans.status.get(order_id: 'order-101')
# Returns: MidtransApi::Model::Check::Status

# Access response attributes
puts status.transaction_status  # e.g., 'settlement', 'pending', 'cancel'
puts status.order_id
puts status.gross_amount
```

#### Expire Transaction

```ruby
expire_response = midtrans.expire_transaction.post(order_id: 'order-101')
# Returns: MidtransApi::Model::Transaction::Expire
```

#### Custom Expiry

```ruby
charge_params = {
  payment_type: 'bank_transfer',
  bank_transfer: {
    bank: 'permata'
  },
  transaction_details: {
    order_id: 'order-106',
    gross_amount: 145000
  },
  custom_expiry: {
    order_time: '2024-12-07 11:54:12 +0700',  # Optional: defaults to current time
    expiry_duration: 60,
    unit: 'minute'  # Options: second, minute, hour, day
  }
}

charge = midtrans.charge_transaction.post(charge_params, 'bank_transfer')
# Returns: MidtransApi::Model::Transaction::Charge
```

### Merchant Management

#### Create Merchant

```ruby
merchant_params = {
  email: 'merchant@midtrans.com',
  merchant_name: 'My Merchant',
  callback_url: 'https://merchant.com/midtrans-callback',
  notification_url: 'https://merchant.com/midtrans-notification',
  pay_account_url: 'https://merchant.com/pay-account-notification',
  owner_name: 'Owner Name',
  merchant_phone_number: '81211111111',
  mcc: 'Event',
  entity_type: 'corporate',
  business_name: 'PT Business Name'
}

merchant = midtrans.merchant.post(merchant_params, 'partner_id')
# Returns: MidtransApi::Model::Merchant::Create
```

#### Update Merchant Notification URLs

```ruby
notification_params = {
  payment_notification_url: 'https://merchant.com/payment-notification',
  iris_notification_url: 'https://merchant.com/payout-notification',
  recurring_notification_url: 'https://merchant.com/recurring-notification',
  pay_account_notification_url: 'https://merchant.com/pay-account-notification',
  finish_payment_redirect_url: 'https://merchant.com/payment-finish'
}

response = midtrans.merchant_update_notification.patch(
  notification_params,
  'partner_id',
  'merchant_id'
)
# Returns: MidtransApi::Model::Merchant::UpdateNotification
```

### Disbursements

#### Create Payout

```ruby
payout_params = {
  payouts: [
    {
      beneficiary_name: 'John Doe',
      beneficiary_account: '1234567890',
      beneficiary_bank: 'bca',
      beneficiary_email: 'john@example.com',
      amount: 100000,
      notes: 'Payout for invoice #123'
    }
  ]
}

payout = midtrans.payout.post(payout_params)
# Returns: MidtransApi::Model::Disbursement::Payout
```

### Utilities

#### Check Balance

```ruby
balance = midtrans.balance.get
# Returns: MidtransApi::Model::Check::Balance
```

#### List Channels

```ruby
channels = midtrans.channel.get('partner_id', 'merchant_id')
# Returns: Array of channels with virtual account information
```

## Error Handling

The gem raises custom exceptions for various error scenarios:

```ruby
begin
  charge = midtrans.gopay_charge.post(charge_params)
rescue MidtransApi::Errors::ApiError => e
  puts "API Error: #{e.message}"
  puts "Status Code: #{e.status_code}"
rescue MidtransApi::Errors::AuthenticationError => e
  puts "Authentication failed: #{e.message}"
rescue MidtransApi::Errors::ValidationError => e
  puts "Validation failed: #{e.message}"
end
```

For more information about status codes and error handling, see the [Midtrans API documentation](https://api-docs.midtrans.com/#status-code).

## Development

After checking out the repo, run the following to set up your development environment:

```bash
$ bin/setup              # Install dependencies
$ rake spec              # Run all tests
$ bin/console            # Interactive console for experimentation
```

### Running Specific Tests

```bash
$ bundle exec rspec spec/path/to/file_spec.rb       # Run specific test file
$ bundle exec rspec spec/path/to/file_spec.rb:42    # Run test at specific line
```

### Building and Installing Locally

```bash
$ bundle exec rake install   # Install gem locally
$ bundle exec rake release   # Release new version (creates git tag, pushes to rubygems)
```

## API Documentation

For complete API documentation and reference, visit:
- [Midtrans API Documentation](https://api-docs.midtrans.com/)
- [Midtrans Dashboard](https://dashboard.midtrans.com/)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mekari-engineering/midtrans_api_ruby.

To contribute:
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Write tests for your changes
4. Ensure all tests pass (`rake spec`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin feature/my-new-feature`)
7. Create a Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
