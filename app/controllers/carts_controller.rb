class CartsController < ApplicationController
    before_action :authorize
   protect_from_forgery with: :null_session
   # Fetching the user's cart
   def show
     cart = @current_user.cart
 
     if cart
       render json: cart, include: :cart_items
     else
       render json: { error: "Cart not found" }, status: :not_found
     end
   end
 
   # Adding a product to the cart
   def add_to_cart
     user = @current_user
     cart = user.cart || user.create_cart
   
     product = Product.find_by(id: params[:product_id])
   
     if product.nil?
       render json: { error: "Product not found" }, status: :not_found
     else
       cart_item = cart.cart_items.find_or_initialize_by(product_id: params[:product_id])
       cart_item.quantity += 1
   
       if cart_item.save
         render json: cart, include: :cart_items
       else
         render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
       end
     end
   end
   
   # Removing a product from the cart
   def remove_from_cart
     product = Product.find(params[:product_id])
     cart_item = current_user.cart.cart_items.find_by(product: product)
 
     if cart_item
       cart_item.destroy
       render json: { message: "Product removed from the cart successfully" }
     else
       render json: { error: "Product not found in the cart" }, status: :not_found
     end
   end
 end