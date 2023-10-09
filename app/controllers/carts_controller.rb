class CartsController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated

  # def add_to_cart
  #   # Retrieve the product_id, quantity, and current_user from the params hash
  #   product_id = params[:product_id]
  #   quantity = params[:quantity]
  #   current_user = current_user # If you have Devise set up, it should provide the current_user
  #   Rails.logger.info("Current User: #{current_user.inspect}")

  #   # Find the product
  #   product = Product.find(product_id)
  
  #   # Check if the current user has a cart, and if not, create one
  #   if current_user.cart.nil?
  #     current_user.cart = Cart.new
  #   end
  
  #   # Check if the product is already in the cart
  #   order_item = current_user.cart.order_items.find_by(product_id: product_id)
  
  #   if order_item
  #     # If the product is already in the cart, update its quantity
  #     order_item.update(quantity: order_item.quantity + quantity.to_i)
  #   else
  #     # If the product is not in the cart, create a new order_item
  #     order_item = current_user.cart.order_items.build(product: product, quantity: quantity)
  #   end
  
  #   # Save the changes to the cart and the order item
  #   current_user.save
  #   order_item.save

  #   # You may want to provide a response here, such as a redirect or JSON response
  # end
  def add_to_cart
    # Retrieve the product_id, quantity, and current_user from the params hash
    product_id = params[:product_id]
    quantity = params[:quantity]
    Rails.logger.info("Current User: #{current_user.inspect}")
  
    # Find the product
    product = Product.find_by(id: product_id)
  
    if product.nil?
      # Handle the case where the product doesn't exist
      flash[:error] = "Product not found."
      redirect_to root_path # You can customize this redirect as needed
      return
    end
  
    # Check if the current user has a cart, and if not, create one
    if current_user.cart.nil?
      current_user.cart = Cart.new
    end
  
    # Check if the product is already in the cart
    order_item = current_user.cart.order_items.find_by(product_id: product_id)
  
    if order_item
      # If the product is already in the cart, update its quantity
      order_item.update(quantity: order_item.quantity + quantity.to_i)
    else
      # If the product is not in the cart, create a new order_item
      order_item = current_user.cart.order_items.build(product: product, quantity: quantity)
    end
  
    # Save the changes to the cart and the order item
    if current_user.save && order_item.save
      flash[:success] = "Product added to cart successfully." # You can customize this message
      # redirect_to cart_path # You can customize this redirect as needed
    else
      # Handle the case where there was an error saving
      flash[:error] = "There was an error adding the product to the cart."
      # redirect_to root_path # You can customize this redirect as needed
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
  
  def update
    cart_item = current_user.cart.cart_items.find(params[:cart_item_id])
    new_quantity = params[:new_quantity]
  
    if cart_item.update(quantity: new_quantity)
      render json: { message: 'Cart item quantity updated' }
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
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
