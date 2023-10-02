class OrdersController < ApplicationController


  before_action :authenticate_user!

  def index
  end
  
  def update
  end

  def destroy
    @order =order.delete()
    
  end

  def create
    @order = Order.new(order_params)
  
    if @order.save
      # Assuming you have a Receipt model and a send_receipt method in your ReceiptMailer
      ReceiptMailer.send_receipt(current_user, @order).deliver_now
  
      flash[:success] = 'Order placed successfully. Receipt sent to your email.'
      redirect_to root_path
    else
      # Handle validation errors or other issues
      flash.now[:error] = 'Error processing the order.'
      render 'new'
    end
  end
  
  

  # ...
end
