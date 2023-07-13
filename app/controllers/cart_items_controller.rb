sclass CartItemsController < ApplicationController

before_action :authorize
    # Updating the quantity of a cart item
    protect_from_forgery with: :null_session
    def update
      cart_item = CartItem.find_by(id: params[:id])
  
      if cart_item
        cart_item.update(quantity: params[:quantity])
        render json: cart_item.cart, include: :cart_items
      else
        render json: { error: "Cart item not found" }, status: :not_found
      end
    end
  
    # Removing a cart item
    def destroy
      cart_item = CartItem.find_by(id: params[:id])
  
      if cart_item
        cart_item.destroy
        render json: cart_item.cart, include: :cart_items
      else
        render json: { error: "Cart item not found" }, status: :not_found
      end
    end
  end
  
class CartsController < ApplicationController
  # Fetching the user's cart
  protect_from_forgery with: :null_session

  before_action :authorize
  def show
    cart = Cart.find_by(user_id: params[:user_id])

    if cart
      render json: cart, include: :cart_items
    else
      render json: { error: "Cart not found" }, status: :not_found
    end
  end

  # Adding a product to the cart
  def add_to_cart
    cart = Cart.find_or_create_by(user_id: params[:user_id])
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
    cart = Cart.find_by(user_id: params[:user_id])
    cart_item = cart&.cart_items&.find_by(product_id: params[:product_id])

    if cart_item
      if cart_item.destroy
        render json: cart, include: :cart_items
      else
        render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Cart item not found" }, status: :not_found
    end
  end
end