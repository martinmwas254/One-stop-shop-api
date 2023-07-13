Rails.application.routes.draw do
  resources :users, only: [:index, :create, :show]
  post "/api/login", to:"users#login"
  delete "/api/logout", to:"users#logout"

  get "/api/current_user", to:"users#loggedin_user"
  
  resources :products, only: [:index, :create, :show, :destroy] do
    resources :reviews, only: [:index, :create, :show]
  end

  resources :carts, only: [:index, :create, :show, :update, :destroy] do
    post 'add_to_cart/:product_id', action: :add_to_cart, on: :member, as: :add_to_cart
    # The above line adds the route for adding a product to the cart

    # If you want to remove a product from the cart, you can add a similar route:
    delete 'remove_from_cart/:product_id', action: :remove_from_cart, on: :member, as: :remove_from_cart
  end

  resources :cart_items, only: [:index, :create, :update, :destroy]
  resources :orders, only: [:index, :create, :show, :destroy]

  # Other routes for additional models or custom actions can be defined here
end