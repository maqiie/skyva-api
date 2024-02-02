
  
# class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
#   def create
#     super do |resource|
#       if resource.persisted?
#         # Create a cart for the new user
#         Cart.create(user: resource)
#       end
#     end
#   end

#   private
#   def sign_up_params
#     params.require(:user).permit(:name, :email, :password, :password_confirmation)
#   end
  
  
# end
class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        # Create a cart for the new user
        Cart.create(user: resource)

        # Set the user with ID 1 as an admin
        resource.update(admin: true) if resource.id == 1
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
