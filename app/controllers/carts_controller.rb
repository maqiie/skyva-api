class CartsController < ApplicationController
  # POST /add_to_cart
  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity]

    render json: { message: 'Product added to cart' }, status: :created
  end

  def show
    cart_items = current_user.cart.cart_items
    render json: { cart_items: cart_items }
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
  def calculate_cart_total
    cart_items.sum(&:subtotal)
  end
      
end
