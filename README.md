# midtrans_api_ruby

Midtrans API client library for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mekari-midtrans-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mekari-midtrans-api

## Usage

### Build client
```ruby
require 'midtrans_api'

midtrans = MidtransApi::Client.new(
  client_key: 'YOUR-CLIENT-KEY',
  server_key: 'YOUR-SERVER-KEY',
  sandbox: true|false,
  notification_url: 'https://example.com/callback',
  timeout: 30 # by default will be 60 (seconds)
)

# or

midtrans = MidtransApi::Client.new do |client|
  client.client_key = 'YOUR-CLIENT-KEY'
  client.server_key = 'YOUR-SERVER-KEY'
  client.sandbox_mode = true|false
  client.notification_url = 'https://example.com/callback'
end
```

### Basic usage

#### Credit Card Online Installment Charge
```ruby
# get credit card token
credit_card_params = {
  currency: 'IDR',
  gross_amount: 12500,
  card_number: 5573381072196900,
  card_exp_month: 02,
  card_exp_year: 2025,
  card_cvv: 123
}

credit_card_token = midtrans.credit_card_token.get(credit_card_params)
#=> credit_card_token returns MidtransApi::Model::CreditCard::Token instance

charge_params = {
  "payment_type": 'credit_card',
  "transaction_details": {
    "order_id": 'order-with-credit_card_installment',
    "gross_amount": 12500
  },
  "credit_card": {
    "token_id": credit_card_token.token_id,
    "authentication": true,
    "installment_term": 3,
    "bank": 'mandiri',
    "bins": [
      'mandiri'
    ]
  },
  "customer_details": {
    "first_name": 'Budi',
    "last_name": 'Utomo',
    "email": 'test@midtrans.com',
    "phone": '081111333344'
  },
  "item_details": [
    {
      "id": 'invoice-1',
      "price": 12500,
      "quantity": 1,
      "name": 'Invoice #1'
    }
  ]
}

credit_card_charge = midtrans.credit_card_charge.post(charge_params)
#=> credit_card_charge returns MidtransApiMidtransApi::Model::CreditCard::Charge instance
```

#### Gopay Charge
```ruby
charge_params = {
  "payment_type": "gopay",
  "transaction_details": {
      "order_id": "order-with-gopay",
      "gross_amount": 12500
  },
  "item_details": [
      {
          "id": "bluedio-turbine",
          "price": 12500,
          "quantity": 1,
          "name": "Bluedio H+ Turbine Headphone with Bluetooth 4.1 -"
      }
  ],
  "customer_details": {
      "first_name": "Budi",
      "last_name": "Utomo",
      "email": "budi.utomo@midtrans.com",
      "phone": "081223323423"
  },
  "gopay": {
      "enable_callback": true,
      "callback_url": "someapps://callback"
  }
}

gopay_charge = midtrans.gopay_charge.post(charge_params)
#=> gopay_charge returns MidtransApiMidtransApi::Model::Gopay::Charge instance
```

#### BCA Virtual Account Charge
```ruby
charge_params = {
  "payment_type": "bank_transfer",
  "transaction_details": {
      "order_id": "order-with-bca-virtua-account",
      "gross_amount": 12500
  },
  "item_details": [
      {
          "id": "bluedio-turbine",
          "price": 12500,
          "quantity": 1,
          "name": "Bluedio H+ Turbine Headphone with Bluetooth 4.1 -"
      }
  ],
  "customer_details": {
      "first_name": "Budi",
      "last_name": "Utomo",
      "email": "budi.utomo@midtrans.com",
      "phone": "081223323423"
  },
  "bank_transfer": {
    "bank": "bca",
    "va_number": "11111111",
    "free_text": {
      "inquiry": [
        {
          "id": "Free Text Inquiry ID",
          "en": "Free Text Inquiry EN"
        }
      ],
      "payment": [
        {
          "id": "Free Text Payment ID",
          "en": "Free Text Payment EN"
        }
      ]
    }
  },
  "bca": {
      "sub_company_code": "000"
    }
}

bca_virtual_account_charge = midtrans.bca_virtual_account_charge.post(charge_params)
#=> bca_virtual_account_charge returns MidtransApiMidtransApi::Model::BcaVirtualAccount::Charge instance
```

#### Expire Transaction
```ruby
expire_response = midtrans.expire_transaction.post(order_id: "eb046679-285a-4136-8977-e4c429cc3254")
#=> expire_response returns MidtransApiMidtransApi::Model::Transaction::Expire instance
```

#### Charge Transaction
Charge transaction for payment type **bank_transfer**
Available for these bank:
- permata
- bni
- bri
- cimb

```ruby
# "payment_type" => required
# "transaction_details" => required
# "customer_details" => optional
# "item_details" => optional
# "bank_transfer" => required
charge_params = {
    "payment_type": "bank_transfer",
    "transaction_details": {
        "gross_amount": 10000,
        "order_id": "{{$timestamp}}" # specified by you
    },
    "customer_details": {
        "email": "budi.utomo@Midtrans.com",
        "first_name": "budi",
        "last_name": "utomo",
        "phone": "+6281 1234 1234"
    },
    "item_details": [
    {
       "id": "1388998298204",
       "price": 5000,
       "quantity": 1,
       "name": "Ayam Zozozo"
    },
    {
       "id": "1388998298205",
       "price": 5000,
       "quantity": 1,
       "name": "Ayam Xoxoxo"
    }
   ],
   "bank_transfer":{
     "bank": "bni|bri|permata|cimb",
     "va_number": "111111"
  }
}

charge_response = midtrans.charge_transaction.post(charge_params)
#=> charge_response returns MidtransApiMidtransApi::Model::Transaction::Charge instance
```

#### Check Status Payment
```ruby
dummy_order_id = "order-with-gopay"
check_status = midtrans.status.get(order_id: dummy_order_id)
#=> check_status returns MidtransApi::Model::Check::Status
```

About official documentation api of Midtrans API, see [API doc](https://api-docs.midtrans.com/)

### Errors (Sample)
MidtransApi can raise conditional Errors explained from Midtrans Documentation.
About available Status Code, see [Midtrans API doc](https://api-docs.midtrans.com/#status-code)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mekari-engineering/midtrans_api_ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
