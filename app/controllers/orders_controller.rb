class OrdersController < ApplicationController
    before_action :authorize
    protect_from_forgery with: :null_session
  
    def index
      user = User.find(params[:user_id])
      orders = user.orders.includes(:products)
  
      render json: orders, include: { products: { only: [:id, :name, :price] } }
    end
  
    def create
      user = @current_user
      cart = user&.cart
    
      if cart.nil? || cart.cart_items.empty?
        render json: { error: "Cart is empty. Add products to the cart before placing an order." }, status: :unprocessable_entity
        return
      end
    
      order = Order.new(user: user)
      order.total_price = calculate_total_price(cart)
    
      if order.save
        # Move cart items to order items
        cart.cart_items.each do |cart_item|
          order.order_items.create(product: cart_item.product, quantity: cart_item.quantity)
        end
    
        # Clear the cart after creating the order
        cart.cart_items.destroy_all
    
        render json: order, status: :created
      else
        render json: { error: order.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def show
      order = Order.find_by(id: params[:id])
  
      if order
        render json: order, include: :order_items
      else
        render json: { error: "Order not found" }, status: :not_found
      end
    end
  
    def destroy
      order = Order.find_by(id: params[:id])
  
      if order
        order.destroy
        render json: { message: "Order cancelled successfully" }
      else
        render json: { error: "Order not found" }, status: :not_found
      end
    end
  
    private
    
    
  
    def calculate_total_price(cart)
      total_price = 0
  
      cart.cart_items.each do |cart_item|
        total_price += cart_item.product.price * cart_item.quantity
      end
  
      total_price
    end
  end