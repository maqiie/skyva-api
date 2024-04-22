# app/controllers/products_controller.rb

class ProductsController < ApplicationController
  before_action :require_admin, only:[:create, :destroy_all]

  def index
    @products = Product.all
    render json: @products.map { |product| product_with_image_url(product) }
  end
  
 
  def destroy
    @product = Product.find(params[:id])

    if @product.destroy
      render json: { message: 'Product was successfully deleted' }, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end



  def index_by_category
    @category = Category.find(params[:category_id])
    @products = @category.products.with_attached_image
    render json: @products.map { |product| product_with_image_url(product) }
  end
  

  def index
    @products = Product.all
    render json: @products.map { |product| product_with_image_url(product) }
  end
  


  

  def create
    @product = Product.new(product_params)
    
    # Set the on_offer attribute based on the incoming parameter
    @product.on_offer = params[:product][:on_offer] if params[:product][:on_offer].present?
    
    if @product.save
      image_url = nil
      
      # Handle image upload here if the image parameter is present
      if params[:product].present? && params[:product][:image].present?
        begin
          @product.image.attach(params[:product][:image])
          image_url = url_for(@product.image) # Get the URL of the attached image
        rescue => e
          # Handle image upload failure
          @product.destroy # Rollback the product creation if image upload fails
          return render json: { error: "Failed to upload image: #{e.message}" }, status: :unprocessable_entity
        end
      end
      
      render json: { 
        message: 'Product was successfully created', 
        product: @product.as_json.merge(image_url: image_url)
      }, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  

  def on_offer
    @products = Product.on_offer.with_attached_image
    render json: @products.map { |product| product_with_image_url(product) }
  end
  
  def recently_added
    @products = Product.recently_added.with_attached_image
    render json: @products.map { |product| product_with_image_url(product) }
  end
  
  private
  
  def product_with_image_url(product)
    product_data = product.as_json
    if product.image.attached?
      product_data["image_url"] = rails_blob_path(product.image, only_path: true)
    end
    product_data
  end
  

  def destroy_all
    begin
      Product.transaction do
        # Delete associated records first
        AssociatedModel.destroy_all
        
        # Then delete all products
        Product.destroy_all
      end

      render json: { message: 'All products were successfully deleted' }, status: :ok
    rescue StandardError => e
      render json: { error: "Failed to delete products: #{e.message}" }, status: :unprocessable_entity
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
