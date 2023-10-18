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
   

  # def add_to_cart
  #   product_id = params[:product_id]
  #   quantity = params[:quantity]
  
  #   # Find the product
  #   product = Product.find_by(id: product_id)
  
  #   unless product
  #     render json: { error: "Product not found." }, status: :not_found
  #     return
  #   end
  
  #   unless current_user
  #     render json: { error: "User not found." }, status: :not_found
  #     return
  #   end
  
  #   current_cart = current_user.current_cart
  
  #   unless current_cart
  #     current_cart = current_user.create_current_cart
  #   end
  
  #   order_item = nil  # Initialize order_item variable
  
  #   # Start a transaction
  #   ActiveRecord::Base.transaction do
  #     # Create the order item
  #     order_item = OrderItem.new(product: product, quantity: quantity, cart: current_cart)
      
  #     # Find or create an open order associated with the current cart
  #     order = current_cart.orders.find_or_create_by(status: 'open')
  
  #     # Associate the order_item with the order
  #     order_item.order = order
  
  #     # Attempt to save the order_item
  #     unless order_item.save
  #       errors = order_item.errors.full_messages
  #       raise ActiveRecord::Rollback
  #       render json: { error: "There was an error adding the product to the cart", errors: errors }, status: :unprocessable_entity
  #       return
  #     end
  
  #     # Save current_user and current_cart
  #     unless current_user.save && current_cart.save
  #       errors = []
  #       errors << "User is invalid" if current_user.errors.present?
  #       errors << "Cart is invalid" if current_cart.errors.present?
  #       raise ActiveRecord::Rollback
  #       render json: { error: "There was an error adding the product to the cart", errors: errors }, status: :unprocessable_entity
  #       return
  #     end
  #   end
  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity]
  
    # Find the product
    product = Product.find_by(id: product_id)
  
    unless product
      render json: { error: "Product not found." }, status: :not_found
      return
    end
  
    unless current_user
      render json: { error: "User not found." }, status: :not_found
      return
    end
  
    current_cart = current_user.current_cart
  
    unless current_cart
      current_cart = current_user.create_current_cart
    end
  
    # Check if the product is already in the cart
    order_item = current_cart.order_items.find_by(product: product)
  
    if order_item
      # If the product is already in the cart, update the quantity
      order_item.quantity += quantity
    else
      # If the product is not in the cart, create a new OrderItem
      order_item = OrderItem.new(product: product, quantity: quantity, cart: current_cart)
    end
  
    # Start a transaction
    ActiveRecord::Base.transaction do
      # Find or create an open order associated with the current cart
      order = current_cart.orders.find_or_create_by(status: 'open')
  
      # Associate the order_item with the order
      order_item.order = order
  
      # Attempt to save the order_item
      unless order_item.save
        errors = order_item.errors.full_messages
        raise ActiveRecord::Rollback
        render json: { error: "There was an error adding the product to the cart", errors: errors }, status: :unprocessable_entity
        return
      end
  
      # Save current_user and current_cart
      unless current_user.save && current_cart.save
        errors = []
        errors << "User is invalid" if current_user.errors.present?
        errors << "Cart is invalid" if current_cart.errors.present?
        raise ActiveRecord::Rollback
        render json: { error: "There was an error adding the product to the cart", errors: errors }, status: :unprocessable_entity
        return
      end
    end
  
    # Check if order_item is defined and has an id
    if order_item && order_item.id
      render json: { message: "Product added to cart successfully", cart_id: current_user.current_cart.id, order_item_id: order_item.id }
    else
      render json: { error: "There was an error adding the product to the cart" }, status: :unprocessable_entity
    end
  end
  

  
 

  
  def get_cart
    # Replace this with your actual logic to retrieve cart contents
    @cart_contents = Cart.find(params[:id])  # Example logic, adjust as needed

    respond_to do |format|
      format.json { render json: @cart_contents }
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
  
    if cart.nil?
      render json: { errors: 'User does not have a cart' }, status: :not_found
      return
    end
  
    order_item = cart.order_items.find_by(id: params[:order_item_id])
  
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

  def remove_item(product_id)
    # Find the order item for the given product
    order_item = order_items.find_by(product_id: product_id)

    if order_item
      # If the item is in the cart, destroy it
      order_item.destroy
      save
    end
  end


  def clear_cart
    # Destroy all order items associated with the cart
    order_items.destroy_all
  end


  private

  def cart_params
    params.permit(:product_id, :quantity)
  end
      
end
end
