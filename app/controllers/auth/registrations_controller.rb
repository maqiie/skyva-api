

class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController


  def index
    @users = User.includes(:orders)
    render json: @users.to_json(include: :orders)
  end
  
  
  
  def create
    super do |resource|
      if resource.persisted?
        # Create a cart for the new user
        cart = Cart.create(user: resource)

        # Set the user with ID 1 as an admin
        if resource.id == 1
          resource.update(admin: true, role: 'admin')
        end

        # Construct response data with user and cart ID
        response_data = {
          status: 'success',
          data: {
            user: resource,
            cart_id: cart.id
          }
        }

        # Return the response data as a JSON response
        render json: response_data, status: :created
        return
      end
    end
  end
  def show
    user_id = params[:id] # Assuming user ID is passed as a parameter
    user = User.find_by(id: user_id)

    if user
      cart = user.cart

      if cart
        cart_id = cart.id
        # Do something with the cart ID, like render it in the view
        render json: { user: user, cart_id: cart_id }
      else
        render json: { error: "No cart found for user ID: #{user_id}" }, status: :not_found
      end
    else
      render json: { error: "User not found with ID: #{user_id}" }, status: :not_found
    end
  end
  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end