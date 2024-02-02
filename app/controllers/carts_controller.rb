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
  #   quantity = params[:quantity].to_i

  #   # Make sure the product exists
  #   product = Product.find_by(id: product_id)
  #   unless product
  #     render json: { error: "Product not found" }, status: :unprocessable_entity
  #     return
  #   end

  #   # Use the cart associated with the user from the beginning
  #   current_cart = current_user.current_cart

  #   # Check if the product is already in the cart
  #   order_item = current_cart.order_items.find_by(product: product)

  #   if order_item
  #     # If the product is already in the cart, update the quantity
  #     order_item.quantity += quantity
  #   else
  #     # If the product is not in the cart, create a new OrderItem
  #     order_item = OrderItem.new(product: product, quantity: quantity, cart: current_cart)
  #   end

  #   # Start a transaction
  #   ActiveRecord::Base.transaction do
  #     # Find or create an open order associated with the current cart
  #     order = current_cart.orders.find_or_create_by(status: 'open')

  #     # Associate the order_item with the order
  #     order_item.order = order

  #     # Save the order and the order_item
  #     unless order.save && order_item.save
  #       errors = (order.errors.full_messages + order_item.errors.full_messages).uniq
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

  #   render json: { message: "Product added to cart successfully", cart_id: current_cart.id, order_item_id: order_item.id }
  # end
#   def add_to_cart
#     product_id = params[:product_id]
#     quantity = params[:quantity].to_i
#     # Use the cart associated with the user from the beginning
# current_cart = current_user.current_cart

  
#     # Make sure the product exists
#     product = Product.find_by(id: product_id)
#     unless product
#       render json: { error: "Product not found" }, status: :unprocessable_entity
#       return
#     end
  
#     # Use the cart associated with the user from the beginning
#     current_cart = current_user.current_cart
  
#     # Check if the product is already in the cart
#     order_item = current_cart.order_items.find_by(product: product)
  
#     if order_item
#       # If the product is already in the cart, update the quantity
#       order_item.quantity += quantity
#     else
#       # If the product is not in the cart, create a new OrderItem
#       order_item = OrderItem.new(product: product, quantity: quantity, cart: current_cart)
#     end
  
#     # ...

# ActiveRecord::Base.transaction do
#   logger.info "Starting transaction..."

#   # Find or create an open order associated with the current cart and user
#   order = current_user.orders.find_or_create_by(cart: current_cart, status: 'open')
#   logger.info "Found or created order: #{order.inspect}"

#   # ...

#   # Save the order and the order_item
#   unless order.save && order_item.save
#     errors = (order.errors.full_messages + order_item.errors.full_messages).uniq
#     logger.error "Errors: #{errors}"
#     raise ActiveRecord::Rollback
#     render json: { error: "There was an error adding the product to the cart", errors: errors }, status: :unprocessable_entity
#     return
#   end

#   # ...
# end
# ...

# # Save current_user and current_cart
# unless current_user.save && current_cart.save
#   errors = []
#   errors << "User is invalid" if current_user.errors.present?
#   errors << "Cart is invalid" if current_cart.errors.present?
#   raise ActiveRecord::Rollback
#   render json: { error: "There was an error adding the product to the cart", errors: errors }, status: :unprocessable_entity
#   return
# end

# # Product added successfully, return order_item_id
# render json: { message: "Product added to cart successfully", cart_id: current_cart.id, order_item_id: order_item.id }
# end
def add_to_cart
  product_id = params[:product_id]
  quantity = params[:quantity].to_i

  # Make sure the product exists
  product = Product.find_by(id: product_id)
  unless product
    render json: { error: "Product not found" }, status: :unprocessable_entity
    return
  end

  # Use the cart associated with the user from the beginning
  current_cart = current_user.current_cart

  # Find or create an open order associated with the current cart and user
  order = current_user.orders.find_or_create_by(cart: current_cart, status: 'open')

  # Check if the product is already in the cart
  order_item = order.order_items.find_by(product: product)

  if order_item
    # If the product is already in the cart, update the quantity
    order_item.quantity += quantity
  else
    # If the product is not in the cart, create a new OrderItem
    order_item = OrderItem.new(product: product, quantity: quantity, cart: current_cart, order: order)
  end

  # Start a transaction
  ActiveRecord::Base.transaction do
    logger.info "Starting transaction..."

    # Save the order and the order_item
    unless order.save && order_item.save
      errors = (order.errors.full_messages + order_item.errors.full_messages).uniq
      logger.error "Errors: #{errors}"
      raise ActiveRecord::Rollback
      render json: { error: "There was an error adding the product to the cart", errors: errors }, status: :unprocessable_entity
      return
    end

    # ...
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

  # Product added successfully, return order_item_id
  render json: { message: "Product added to cart successfully", cart_id: current_cart.id, order_item_id: order_item.id }
end

def pay_order
  # Assuming you have a payment logic here
  order_id = params[:order_id]
  order = current_user.orders.find_by(id: order_id, status: 'open')

  unless order
    render json: { error: "Order not found or not in open status" }, status: :unprocessable_entity
    return
  end

  # Perform payment logic (update order status, payment details, etc.)
  # ...

  # Close the order
  order.update(status: 'paid')

  render json: { message: "Order paid successfully", order_id: order.id }
end

def complete_order
  order_id = params[:order_id]
  order = current_user.orders.find_by(id: order_id, status: 'paid')

  unless order
    render json: { error: "Order not found or not in paid status" }, status: :unprocessable_entity
    return
  end

  # Perform completion logic (update order status, shipping details, etc.)
  # ...

  # Close the order
  order.update(status: 'completed')

  render json: { message: "Order completed successfully", order_id: order.id }
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
