class OrdersController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  

  def edit
  end

  def update
  end

  def destroy
    @order =order.delete()
    
  end


  # ...

  def create
    # Process the order and save it to the database

    # After the order is successfully completed
    @order = Order.new(order_params)

    if @order.save
      # Generate a receipt (assuming you have a Receipt model)
      @receipt = Receipt.create(order: @order, user: current_user)

      # Send the receipt via email
      ReceiptMailer.send_receipt(@user, @order).deliver_now

      # Redirect to a thank you page or display a success message
      flash[:success] = 'Order placed successfully. Receipt sent to your email.'
      redirect_to root_path
    else
      # Handle validation errors or other issues
      render 'new'
    end
  end

  # ...
end
