# app/controllers/products_controller.rb

class ProductsController < ApplicationController
  before_action :require_admin, only: [:create]


   # GET /products
   def index
    @products = Product.all
    render json: @products
  end
  

  
  def create
    @product = Product.new(product_params)
    
    # Set the on_offer attribute based on the incoming parameter
    @product.on_offer = params[:product][:on_offer] if params[:product][:on_offer].present?
  
    if @product.save
      # Handle image upload here
      if params[:product][:image].present?
        @product.image.attach(params[:product][:image])
      end
      
      render json: { 
        message: 'Product was successfully created', 
        product: @product.as_json
      }, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  
  # app/controllers/products_controller.rb


  def on_offer
    @products = Product.on_offer
    render json: @products
  end
  
  def recently_added
    @products = Product.recently_added
    render json: @products
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
    params.require(:product).permit(:name, :description, :price, :size,:brand, :stock_quantity, :color, :category_id, :image,:on_offer)
  end

  def require_admin
    unless current_user && current_user.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  
end
