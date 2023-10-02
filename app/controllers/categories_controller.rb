class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

   # GET /categories/:id/products
   def products_by_category
    @category = Category.find(params[:id])
    @products = @category.products

    render json: { category: @category, products: @products }
  end
  
  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
