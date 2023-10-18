
# class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  


#   def create
#     super do |user|
#       # After creating the user, check if it's the first user and make them an admin
#       if User.count == 1
#         user.update(role: 'admin')
#       end
#     end
#   end
#     private
   
#     def sign_up_params
#       params.permit(:name, :email, :password, :password_confirmation)
#     end
#   end
  
class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        # Create a cart for the new user
        Cart.create(user: resource)
      end
    end
  end

  private

  def sign_up_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
