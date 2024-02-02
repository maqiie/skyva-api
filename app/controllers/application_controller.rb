class ApplicationController < ActionController::Base
        # before_action :authenticate_user!
        before_action :set_current_cart

        skip_before_action :verify_authenticity_token

        include DeviseTokenAuth::Concerns::SetUserByToken

        rescue_from CanCan::AccessDenied do |exception|
                redirect_to root_path, alert: "Access denied."
              end

              def set_current_cart
                @current_cart ||= current_user&.current_cart || current_user&.create_current_cart
              end
            
              helper_method :current_cart
end
