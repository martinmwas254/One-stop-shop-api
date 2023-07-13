class ReviewsController < ApplicationController
    before_action :find_product
    protect_from_forgery with: :null_session
  
    def index
      reviews = @product.reviews
      render json: reviews
    end
  
    def create
      review = @product.reviews.build(review_params)
  
      if review.save
        render json: review, status: :created
      else
        render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      review = @product.reviews.find_by(id: params[:id])
  
      if review
        render json: review
      else
        render json: { error: "Review not found" }, status: :not_found
      end
    end
  
    private
  
    def find_product
      @product = Product.find_by(id: params[:product_id])
      render json: { error: "Product not found" }, status: :not_found unless @product
    end
  
    def review_params
      params.permit(:rating, :comment)
    end
  end