class CartsController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated

  def add_to_cart
    # product_id = params[:product_id]
    # quantity = params[:quantity]

    # # Find or create the user's cart
    # cart = current_user.cart || current_user.build_cart

    # # Add the product to the cart
    # cart.add_product(product_id, quantity)

    # # Save the cart
    # if cart.save
    #   render json: { message: 'Product added to cart successfully', cart: cart }, status: :created
    # else
    #   render json: { errors: cart.errors.full_messages }, status: :unprocessable_entity
    # end
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


  private

  def cart_params
    params.permit(:product_id, :quantity)
  end
      
end
