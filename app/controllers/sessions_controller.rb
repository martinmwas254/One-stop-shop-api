class SessionController < ApplicationController
    
    protect_from_forgery with: :null_session
 
   def login
     name = params[:name]
     password = params[:password]
 
     user = User.find_by(name: name)
 
     if user && user.authenticate(password)
       session[:user_id] = user.id
 
       render json: { success: "Login success" }
     else
       render json: { error: "Wrong username/password" }
     end
   end


   def logout
       session.delete :user_id
       render json: {success: "Logout success"}

   end

 
end