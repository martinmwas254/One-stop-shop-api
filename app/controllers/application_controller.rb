class ApplicationController < ActionController::Base
    # protect_from_forgery with: :exception
    
    include ActionController::Cookies

    private
    def authorize
       @current_user=User.find_by(id: session[:user_id])
       if !@current_user
          render json: {"error": "not authorized"}
       end
    
    end

end