# app/controllers/products_controller.rb

class ProductsController < ApplicationController
  def create
    @product = Product.new(product_params)
  
    if @product.save
      render json: { message: 'Product was successfully created', product: @product }, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  # Other actions...

  private
  def product_params
    params.require(:product).permit(:name, :description, :price, :size,:brand, :stock_quantity, :color, :category_id)
  end
  
end
