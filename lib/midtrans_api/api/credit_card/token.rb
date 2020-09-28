# frozen_string_literal: true

module MidtransApi
  module Api
    module CreditCard
      class Token < MidtransApi::Api::Base
        PATH = 'token'

        def get(params)
          response = client.get(PATH,
                                client_key: client.config.client_key,
                                currency: params[:currency],
                                gross_amount: params[:gross_amount],
                                card_number: params[:card_number],
                                card_exp_month: params[:card_exp_month],
                                card_exp_year: params[:card_exp_year],
                                card_cvv: params[:card_cvv])
          MidtransApi::Model::CreditCard::Token.new(response)
        end
      end
    end
  end
end
