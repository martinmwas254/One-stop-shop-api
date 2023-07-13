class UsersController < ApplicationController
    #  protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token,  only: [:create, :login, :logout, :loggedin_user]
    
    # before_action :authorize, only: [:create]
    before_action :authorize, only: [:loggedin_user]
  
    def loggedin_user
      if @current_user
        render json: @current_user.slice(:id, :name, :email)
      else
        render json: { error: "Not logged in" }, status: :not_found
      end
    end
  
    def login
      name = params[:name]
      password = params[:password]
    
      user = User.find_by(name: name)
    
      if user && user.authenticate(password)
        session[:user_id] = user.id
    
        # Create a cart for the user if it doesn't exist
        user.create_cart unless user.cart
    
        render json: { success: "Login success" }
      else
        render json: { error: "Wrong username/password" }
      end
    end
    
  
  
    def logout
      session.delete(:user_id)
      render json: { success: "Logout success" }
    end
     
      
  
    def index
      users = User.all
      render json: users
    end
  
    def create
      user = User.new(user_params)
  
      if user.save
        render json: user, status: :created, only: [:id, :name, :email, :password]
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # showing a single user
    def show
      user = User.find_by(id: params[:id])
  
      if user
        render json: user, only: [:id, :name, :email, :password]
      else
        render json: { error: "User not found" }, status: :not_found
      end
    end
  
    private
  
    def user_params
      params.permit(:name, :email, :password)
    end
  end