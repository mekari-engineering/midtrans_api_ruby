# frozen_string_literal: true

module MidtransApi
  module Api
    class Base
      attr_reader :client

      class << self
        def model_name
          name.sub('Api', 'Model')
        end

        def model_class
          Object.const_get(model_name)
        end
      end

      def initialize(client)
        @client = client
      end
    end
  end
end
