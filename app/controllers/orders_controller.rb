class OrdersController < ApplicationController
  before_action :authenticate_user!



  def index
    # Retrieve all orders
    @orders = Order.includes(:order_items).all

    # Filter out orders without order items
    @orders.each do |order|
      order.update(status: 'closed') if order.order_items.empty?
    end

    # Render JSON response
    render json: @orders, include: :order_items
  end


  def order_history
    @closed_orders = current_user.orders.where(status: 'closed')
    total_revenue = @closed_orders.sum(:total_amount)
    render json: { orders: @closed_orders, total_revenue: total_revenue }
  end

  def open_orders
    @open_orders = current_user.orders.where(status: 'open')
    render json: @open_orders
  end
  def close
    order = Order.find(params[:id])
    order.update(status: 'closed')
    # You can add any other logic here, such as sending notifications, updating inventory, etc.
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Order not found' }, status: :not_found
  end


def total_revenue
  total_revenue = Order.where(status: 'closed').sum(:total_amount)
  render json: { total_revenue: total_revenue }
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
