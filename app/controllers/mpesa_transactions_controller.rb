# app/controllers/mpesa_transactions_controller.rb
class MpesaTransactionsController < ApplicationController
    include HTTParty
  
    def stk_push
      response = HTTParty.post(
        'https://sandbox.vm.co.tz/v1/payments/stk/push',
        headers: {
          'Authorization' => 'Bearer YOUR_ACCESS_TOKEN',
          'Content-Type' => 'application/json',
        },
        body: {
          business_shortcode: 'YOUR_BUSINESS_SHORT_CODE',
          password: 'YOUR_PASSWORD',
          timestamp: Time.now.strftime('%Y%m%d%H%M%S'),
          amount: '1', # Amount in TZS
          partyA: 'PHONE_NUMBER_TO_CHARGE',
          partyB: 'YOUR_PAYBILL_NUMBER',
          phone_number: 'PHONE_NUMBER_TO_NOTIFY',
          reference_id: 'UNIQUE_REFERENCE',
          transaction_desc: 'DESCRIPTION',
          callback_url: 'YOUR_CALLBACK_URL',
        }.to_json,
      )
  
      render json: response.parsed_response
    end
  end
  