class OrdersController < ApplicationController


  before_action :authenticate_user!

  def open_orders
    @open_orders = current_user.orders.where(status: 'open')
    render json: @open_orders
  end

  # Custom action to get history of orders
  def order_history
    @order_history = current_user.orders.where.not(status: 'open')
    render json: @order_history
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:product_id, :quantity)
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
