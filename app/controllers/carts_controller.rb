class CartsController < ApplicationController
  # POST /add_to_cart
  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity]

    # Logic to add the product to the cart
    # You can use the `current_user` to associate the cart with the user
    # Example:
    # current_user.cart.add_product(product_id, quantity)

    render json: { message: 'Product added to cart' }, status: :created
  end

  def show
  end

  def update
  end

  def destroy
  end
end
