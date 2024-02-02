
  
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
  
<<<<<<< HEAD
  
=======
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
#     params.permit(:name, :email, :password, :password_confirmation)
#   end
>>>>>>> ceb27d7649c9a9e5a144205fa3b3a48970921d3f
# end
class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        # Create a cart for the new user
        Cart.create(user: resource)

<<<<<<< HEAD
        # Set the user with ID 1 as an admin
        resource.update(admin: true) if resource.id == 1
=======
        # Check if the current user is the first one and assign admin role
        if User.count == 1 && resource.id == 1
          resource.update(role: 'admin')
        end
>>>>>>> ceb27d7649c9a9e5a144205fa3b3a48970921d3f
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
