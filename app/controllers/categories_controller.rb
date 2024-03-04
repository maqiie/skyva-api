class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    render json: @categories
  end

  def show
    @category = Category.find(params[:id])
    render json: @category
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
