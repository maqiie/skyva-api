class FavoritesController < ApplicationController
    before_action :authenticate_user! # Assuming you're using Devise for authentication
  
    def index
      @favorites = current_user.favorites
    end
  
    def create
      @favorite = current_user.favorites.build(favorite_params)
      if @favorite.save
        redirect_to favorites_path, notice: 'Product added to favorites.'
      else
        redirect_to favorites_path, alert: 'Failed to add product to favorites.'
      end
    end
  
    def destroy
      @favorite = current_user.favorites.find(params[:id])
      @favorite.destroy
      redirect_to favorites_path, notice: 'Product removed from favorites.'
    end
  
    private
  
    def favorite_params
      params.require(:favorite).permit(:product_id)
    end
  end
  