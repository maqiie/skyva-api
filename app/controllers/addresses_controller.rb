# app/controllers/addresses_controller.rb
class AddressesController < ApplicationController
  def create
    @address = current_user.addresses.build(address_params)

    if @address.save
      # Handle successful address creation
    else
      # Handle address creation errors
    end
  end

  # Other address-related actions...
  
  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip_code)
  end
end
