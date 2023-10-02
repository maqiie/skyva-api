# app/controllers/receipts_controller.rb
class ReceiptsController < ApplicationController
  def create
    @receipt = Receipt.new(user: current_user, order: @order) # Assuming an association exists
    
    if @receipt.save
      # Handle successful receipt creation
    else
      # Handle receipt creation failure
    end
  end
end
