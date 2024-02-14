

Rails.application.routes.draw do
  # Receipts and Addresses routes
  resources :receipts, only: [:create]
  resources :addresses, except: [:edit]



mount ActionCable.server => '/cable'

  # Carts routes
  resources :carts, only: [:show, :update, :destroy, :create] do
    member do
      post 'add_to_cart', to: 'carts#add_to_cart'
      patch 'add_quantity/:product_id', to: 'carts#add_quantity', as: :add_quantity
      delete 'remove_item/:product_id', to: 'carts#remove_item', as: :remove_item
      delete 'clear_cart', to: 'carts#clear_cart', as: :clear_cart
    end
    get 'get_cart', on: :member
  end
  

  # Order Items and Orders routes
  resources :order_items, only: [:create, :destroy]
  resources :orders, except: [:edit]

  # Products and Categories routes
  resources :products, except: [:edit] do
    collection do
      get 'new', to: 'products#create', as: 'new_product'
      post 'create_product', to: 'products#create', as: 'create_product'
    end
  end

  resources :categories, except: [:edit] do
    member do
      get 'products', to: 'categories#products_by_category'
    end
  end
  post 'create_product', to: 'products#create', as: 'create_product'

  # Authentication routes using Devise Token Auth

  #getcurrentuser
  get '/current_user', to: 'application#index', as: 'current_user'


  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }
  # devise_for :users


  # config/routes.rb

  

end
