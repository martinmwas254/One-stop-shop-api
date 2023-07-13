class ProductsController < ApplicationController
    before_action :authorize, except: :index
    protect_from_forgery with: :null_session
    
  
    def index
      products = Product.all
      render json: products
    end
  
    def approved_products
      products = Product.where(is_approved: true)
      render json: products.as_json(include: :user)
    end
  
    def create
      product = @current_user.products.build(product_params)
  
      if product.save
        render json: product, status: :created
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      product = Product.find_by(id: params[:id])
  
      if product
        render json: product, include: [:reviews]
      else
        render json: { error: "Product not found" }, status: :not_found
      end
    end
     
    def destroy
      product = Product.find_by(id: params[:id])
  
      if product
        product.destroy
        render json: { message: "Product deleted successfully" }
      else
        render json: { error: "Product not found" }, status: :not_found
      end
    end

    private
  
    def product_params
      params.permit(:name, :price, :description, :image) # Adjust the permitted attributes according to your Product model
    end
  end