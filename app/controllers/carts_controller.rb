class CartsController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated
  
  ActiveRecord::Base.transaction do
  def create
    @cart = Cart.new(user: current_user)
    if @cart.save
      # Create an order associated with the cart
      @order = @cart.orders.create(status: 'open', user: current_user)
      # Rest of your code
    else
      # Handle errors
    end
  end
   

   





  def get_cart
    # Replace this with your actual logic to retrieve cart contents
    @cart_contents = Cart.find(params[:id])  # Example logic, adjust as needed

    respond_to do |format|
      format.jsonz { render json: @cart_contents }
      # You can also render an HTML view if needed
      # format.html { render :show }
    end
  end

  
  def show
    cart_items = current_user.cart.cart_items
    cart_total = calculate_cart_total(cart_items)
    render json: { cart_items: cart_items, cart_total: cart_total }
  end

  
  
  # Modify calculate_cart_total to accept cart items as a parameter
  def calculate_cart_total(cart_items)
    cart_items.sum(&:subtotal)
  end
  

  def add_quantity
    cart = current_user.cart
    order_item_id = params[:product_id] # Change the parameter name
    
    if cart.nil?
      render json: { errors: 'User does not have a cart' }, status: :not_found
      return
    end
  
    order_item = cart.order_items.find_by(id: order_item_id) # Use the correct parameter name
    
    if order_item.nil?
      render json: { errors: 'Order item not found in the cart' }, status: :not_found
      return
    end
  
    new_quantity = params[:quantity].to_i
  
    # Calculate the updated quantity
    updated_quantity = order_item.quantity + new_quantity
  
    if updated_quantity < 0
      # If the updated quantity is negative, you might want to handle removal logic here
      order_item.destroy
    else
      # Update the order item's quantity
      order_item.update(quantity: updated_quantity)
    end
  
    render json: { message: 'Quantity updated successfully' }, status: :ok
  end
  
  
  
  def destroy
    cart_item = current_user.cart.cart_items.find(params[:cart_item_id])
  
    if cart_item.destroy
      render json: { message: 'Cart item removed' }
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def clear_cart
    current_user.cart.cart_items.destroy_all
    render json: { message: 'Cart cleared' }
  end


  def remove_item
    product_id = params[:product_id]
    
    # Find the order item for the given product
    order_item = current_user.cart.order_items.find_by(product_id: product_id)
    
    if order_item
      # If the item is in the cart, destroy it
      order_item.destroy
      render json: { message: 'Product removed from the cart successfully' }
    else
      render json: { error: 'Product not found in the cart' }, status: :not_found
    end
  end
  
  



  private

  def cart_params
    params.permit(:product_id, :quantity)
  end
      
end
end
