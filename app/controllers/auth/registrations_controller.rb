class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        # Create a cart for the new user
        Cart.create(user: resource)

        # Set the user with ID 1 as an admin
        if resource.id == 2
          resource.update(admin: true, role: 'admin')
        end
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

# class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
#   def create
#     super do |resource|
#       if resource.persisted?
#         # Create a cart for the new user
#         Cart.create(user: resource)

#         # Set the user with ID 1 as an admin
#         resource.update(admin: true) if resource.id == 1
#         # Check if the current user is the first one and assign admin role
#         if User.count == 1 && resource.id == 1
#           resource.update(role: 'admin')
#         end
#       end
#     end
#   end

#   private

#   def sign_up_params
#     params.require(:user).permit(:name, :email, :password, :password_confirmation)
#   end
# end
