# class ChargesController < ApplicationController
#     require 'stripe'
# require 'sinatra'

# # This is a public sample test API key.
# # Don’t submit any personally identifiable information in requests made with this key.
# # Sign in to see your own test API key embedded in code samples.
# Stripe.api_key = 'sk_test_51OqvYuHSqaG8Tm1nOQV0qYT9rBWReVyveYzeOYRxY9awBVWw8OXfgT1AVMW33Ci276GBfOyzNWA6KzbjSqnMhcqd00fYVD2yRJ'

# set :static, true
# set :port, 4242

# YOUR_DOMAIN = 'http://localhost:4242'

# post '/create-checkout-session' do
#   content_type 'application/json'

#   session = Stripe::Checkout::Session.create({
#     line_items: [{
#       # Provide the exact Price ID (e.g. pr_1234) of the product you want to sell
#       price: '{{PRICE_ID}}',
#       quantity: 1,
#     }],
#     mode: 'payment',
#     success_url: YOUR_DOMAIN + '?success=true',
#     cancel_url: YOUR_DOMAIN + '?canceled=true',
#   })
#   redirect session.url, 303
# end
# end
# app/controllers/charges_controller.rb

class ChargesController < ApplicationController
    require 'stripe'
  
    def create_checkout_session
      Stripe.api_key = 'sk_test_51OqvYuHSqaG8Tm1nOQV0qYT9rBWReVyveYzeOYRxY9awBVWw8OXfgT1AVMW33Ci276GBfOyzNWA6KzbjSqnMhcqd00fYVD2yRJ'
  
      session = Stripe::Checkout::Session.create({
        line_items: [{
          price: '{{PRICE_ID}}',
          quantity: 1,
        }],
        mode: 'payment',
        success_url: YOUR_DOMAIN + '?success=true',
        cancel_url: YOUR_DOMAIN + '?canceled=true',
      })
  
      redirect_to session.url
    end
  end
  