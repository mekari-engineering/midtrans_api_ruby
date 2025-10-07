# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby gem that provides a client library for the Midtrans Payment Gateway API. The gem wraps various Midtrans API endpoints (payment transactions, virtual accounts, disbursements, merchant management, etc.) with a clean Ruby interface.

## Development Commands

### Running Tests
```bash
rake spec                              # Run all tests
bundle exec rspec spec/path/to/file_spec.rb  # Run specific test file
bundle exec rspec spec/path/to/file_spec.rb:LINE  # Run specific test at line
```

### Interactive Console
```bash
bin/console    # IRB console with the gem loaded
```

### Build and Install
```bash
bundle exec rake install   # Install gem locally
bundle exec rake release   # Release new version (tags, pushes to rubygems)
```

## Architecture

### Client Architecture
The gem follows a layered architecture pattern:

1. **Client Layer** (`lib/midtrans_api/client.rb`)
   - Main entry point that users interact with
   - Manages Faraday HTTP connection with Basic Auth
   - Provides convenience methods that return API instances (e.g., `client.gopay_charge`, `client.merchant`)
   - Supports three API environments via configuration: production, sandbox, and partner API
   - HTTP methods: `get()`, `post()`, `patch()`

2. **API Layer** (`lib/midtrans_api/api/*`)
   - Each API endpoint has its own class that inherits from `MidtransApi::Api::Base`
   - Organized by feature domain (e.g., `Merchant::Create`, `Gopay::Charge`, `Transaction::Expire`)
   - API classes define the endpoint `PATH` constant and HTTP method (e.g., `post()`, `patch()`)
   - Responsible for making HTTP requests via the client and returning Model instances

3. **Model Layer** (`lib/midtrans_api/model/*`)
   - Each API response is mapped to a Model class that inherits from `MidtransApi::Model::Base`
   - Models use `resource_attributes` macro to define accessible response fields
   - Base class handles initialization from API response hash via `assign_attributes`
   - Models implement `resolve_params_attr()` for key transformation (typically identity transform)

4. **Configuration** (`lib/midtrans_api/configure.rb`)
   - Manages API credentials (client_key, server_key)
   - Environment selection (sandbox vs production vs partner API)
   - Optional features: notification URL override, logging, timeout settings

### Adding New API Endpoints

To add a new Midtrans API endpoint:

1. **Create API class** at `lib/midtrans_api/api/{domain}/{action}.rb`:
   ```ruby
   class MyApi < MidtransApi::Api::Base
     PATH = 'endpoint/path'

     def post(params, additional_headers_params)
       response = client.post(PATH, params, {
         'X-CUSTOM-HEADER': additional_headers_params
       })
       MidtransApi::Model::Domain::MyApi.new(response)
     end
   end
   ```

2. **Create Model class** at `lib/midtrans_api/model/{domain}/{action}.rb`:
   ```ruby
   class MyApi < MidtransApi::Model::Base
     resource_attributes :field1, :field2, :field3

     def resolve_params_attr(attr)
       attr.to_s  # or custom transformation
     end
   end
   ```

3. **Register in Client** (`lib/midtrans_api/client.rb`):
   - Add `require` statements at the top for both API and Model files
   - Add convenience method to instantiate the API class:
     ```ruby
     def my_api
       @my_api ||= MidtransApi::Api::Domain::MyApi.new(self)
     end
     ```
   - If using new HTTP verb, add method (e.g., `put()`, `delete()`)

4. **Create test file** at `spec/lib/midtrans_api/api/{domain}/{action}_spec.rb`:
   - Use WebMock to stub HTTP requests
   - Test that correct model instance is returned
   - Test that proper headers are sent
   - Follow pattern from existing specs (e.g., `merchant/create_spec.rb`)

### Error Handling
- Custom errors defined in `lib/midtrans_api/errors.rb`
- Middleware `HandleResponseException` intercepts HTTP errors and raises appropriate exceptions
- See Midtrans API documentation for status codes

### Logging and Security
- Uses Faraday middleware for logging
- `FaradayLogFormatter` provides custom log formatting
- `JsonMasker` and `UrlMasker` utilities mask sensitive data in logs
- Configure via `filtered_logs` and `mask_params` client options
