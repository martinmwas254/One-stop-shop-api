Rails.application.routes.draw do
  resources :users
  resources :reviews
  resources :products
  resources :orders
  resources :carts
  resources :cart_items
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
