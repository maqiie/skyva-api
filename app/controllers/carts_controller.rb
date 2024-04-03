class CartsController < ApplicationController
  # before_action :authenticate_user! # Ensure the user is authenticated
  
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
    cart_id = params[:id]
    current_cart = Cart.find_by(id: cart_id, user: current_user)
    
    unless current_cart
      render json: { error: "Cart not found" }, status: :not_found
      return
    end
    
    # Load the associated order separately
    order = Order.find_by(cart_id: current_cart.id)
    
    puts "Current Cart: #{current_cart.inspect}"
    puts "Associated Order: #{order.inspect}" # Check if the order is loaded
    
    cart_data = {
      id: current_cart.id,
      user_id: current_cart.user_id,
      created_at: current_cart.created_at,
      updated_at: current_cart.updated_at,
      order_id: current_cart.order_id
    }
    
    order_data = order.present? ? order.attributes : nil
    
    order_items_data = nil
    if order.present?
      order_items_data = order.order_items.map do |order_item|
        order_item.attributes.merge(product: order_item.product.attributes)
      end
    end
    
    render json: {
      cart: cart_data,
      order: order_data,
      order_items: order_items_data
    }, include: [:order, :'order.order_items', :'order_items.product']
  end
  

def add_to_cart
  product_id = params[:product_id]
  quantity = params[:quantity].to_i

  # Step 1: Validate product existence
  product = Product.find_by(id: product_id)
  unless product
    return render json: { error: "Product not found" }, status: :unprocessable_entity
  end

  # Step 2: Retrieve the user's current cart
  current_cart = current_user.current_cart

  # Step 3: Find the open order associated with the user's cart
  order = current_user.orders.find_by(cart: current_cart, status: 'open')

  # Step 4: If no open order exists, create a new one
  unless order
    order = current_user.orders.create(cart: current_cart, status: 'open')
  end

  # # Step 5: Find or initialize the order item for the product
  # order_item = order.order_items.find_or_initialize_by(product: product)
  # order_item.quantity ||= 0
  # order_item.quantity += quantity
  # order_item.cart = current_cart # Associate order item with the cart

  # # Step 6: Handle database operations in a transaction
  # ActiveRecord::Base.transaction do
  #   begin
  #     order.save!
  #     order_item.save!
  #     current_user.save!
  #     current_cart.save!
  #   rescue ActiveRecord::RecordInvalid => e
  #     # Rollback transaction if any operation fails
  #     logger.error "Error adding product to cart: #{e.message}"
  #     raise ActiveRecord::Rollback
  #     return render json: { error: "There was an error adding the product to the cart", errors: e.record.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end
  # Step 5: Find or initialize the order item for the product
order_item = order.order_items.find_or_initialize_by(product: product)
order_item.quantity ||= 0
order_item.quantity += quantity
order_item.cart = current_cart # Associate order item with the cart

# Set the price for the order item based on the product
order_item.price = product.price

# Step 6: Handle database operations in a transaction
ActiveRecord::Base.transaction do
  begin
    order.save!
    order_item.save!
    current_user.save!
    current_cart.save!
  rescue ActiveRecord::RecordInvalid => e
    # Rollback transaction if any operation fails
    logger.error "Error adding product to cart: #{e.message}"
    raise ActiveRecord::Rollback
    return render json: { error: "There was an error adding the product to the cart", errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end


  # Step 7: Render success response
  render json: { message: "Product added to cart successfully", cart_id: current_cart.id, order_item_id: order_item.id }
end

  
  

  
  def show
    cart_items = current_user.cart.cart_items
    cart_total = calculate_cart_total(cart_items)
    render json: { cart_items: cart_items, cart_total: cart_total }
  end
 
    def show
      cart_items = current_user.cart.cart_items
      cart_total = calculate_cart_total(cart_items)
      render json: { cart_items: cart_items, cart_total: cart_total }
    end
  
    def get_cart
      cart_id = params[:id]
      current_cart = Cart.find_by(id: cart_id, user: current_user)
      
      unless current_cart
        render json: { error: "Cart not found" }, status: :not_found
        return
      end
      
      # Load the associated order separately
      order = Order.find_by(cart_id: current_cart.id)
      
      puts "Current Cart: #{current_cart.inspect}"
      puts "Associated Order: #{order.inspect}" # Check if the order is loaded
      
      cart_data = {
        id: current_cart.id,
        user_id: current_cart.user_id,
        created_at: current_cart.created_at,
        updated_at: current_cart.updated_at,
        order_id: current_cart.order_id
      }
      
      order_data = order.present? ? order.attributes : nil
      
      order_items_data = nil
      if order.present?
        order_items_data = order.order_items.map do |order_item|
          order_item.attributes.merge(product: order_item.product.attributes)
        end
      end
      
      render json: {
        cart: cart_data,
        order: order_data,
        order_items: order_items_data
      }, include: [:order, :'order.order_items', :'order_items.product']
    end
    
    

   
   
    
    def add_quantity
      cart = current_user.cart
      order_item_id = params[:order_item_id]
      
      if cart.nil?
        render json: { errors: 'User does not have a cart' }, status: :not_found
        return
      end
      
      order_item = cart.order_items.find_by(id: order_item_id)
      
      if order_item.nil?
        render json: { errors: 'Order item not found in the cart' }, status: :not_found
        return
      end
      
      unless params.key?(:quantity)
        render json: { errors: 'Quantity parameter missing' }, status: :unprocessable_entity
        return
      end
      
      new_quantity = params[:quantity].to_i
      
      if new_quantity <= 0
        # If the updated quantity is zero or negative, remove the order item from the cart
        order_item.destroy
        render json: { message: 'Item removed from cart' }, status: :ok
      else
        # Calculate the updated quantity
        updated_quantity = order_item.quantity + new_quantity
        
        # If the updated quantity is zero, remove the item from the cart
        if updated_quantity <= 0
          order_item.destroy
          render json: { message: 'Item removed from cart' }, status: :ok
        else
          # Update the order item's quantity
          order_item.update(quantity: updated_quantity)
          render json: { message: 'Quantity updated successfully' }, status: :ok
        end
      end
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
    
    order_item_id = params[:order_item_id]
order_item = current_user.cart.order_items.find_by(id: order_item_id)

  
    
    if order_item
      # If the item is in the cart, destroy it
      order_item.destroy
      render json: { message: 'Product removed from the cart successfully' }
    else
      render json: { error: 'Product not found in the cart' }, status: :not_found
    end
  end
  def calculate_cart_total(cart_items)
    cart_items.reduce(0) { |total, item| total + item.quantity * item.product.price }
  end
  
  def clear_cart
    # Find the current user's cart
    cart = current_user.cart
    
    if cart
      # If the cart exists, destroy all its items
      cart.cart_items.destroy_all
      render json: { message: 'Cart cleared successfully' }
    else
      render json: { error: 'Cart not found' }, status: :not_found
    end
  end
  



  private

  def cart_params
    params.permit(:product_id, :quantity)
  end
      
end
end
