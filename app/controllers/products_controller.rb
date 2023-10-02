# app/controllers/products_controller.rb

class ProductsController < ApplicationController

  def create
    @product = Product.new(product_params)

    if @product.save
      # Handle image upload here
      if params[:product][:image].present?
        @product.image.attach(params[:product][:image])
      end
      
      render json: { message: 'Product was successfully created', product: @product }, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

 
  def destroy
    @product = Product.find(params[:id])

    if @product.destroy
      render json: { message: 'Product was successfully deleted' }, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end




  private
  def product_params
    params.require(:product).permit(:name, :description, :price, :size,:brand, :stock_quantity, :color, :category_id, :image)
  end

  
end
