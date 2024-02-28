

# Rails.application.routes.draw do
#   # Receipts and Addresses routes
#   resources :receipts, only: [:create]
#   resources :addresses, except: [:edit]

#   namespace :auth do
#     devise_scope :user do
#       get 'registrations/show', to: 'registrations#show'
#     end
#   end

#   get '/products/on_offer', to: 'products#on_offer'
#   get '/products/recently_added', to: 'products#recently_added'

  


# get '/cart', to: 'carts#show', as: 'cart'


# mount ActionCable.server => '/cable'

#   # Carts routes
#   resources :carts, only: [:show, :update, :destroy, :create] do
#     member do
#       post 'add_to_cart', to: 'carts#add_to_cart'
      
#       patch 'add_quantity/:product_id', to: 'carts#add_quantity', as: :add_quantity
#       delete 'remove_item/:id', to: 'carts#remove_item', as: :remove_item

#       delete 'clear_cart', to: 'carts#clear_cart', as: :clear_cart
#     end
#     get 'get_cart', on: :member
#   end
#   delete 'remove_item/:id', to: 'carts#remove_item', as: :remove_item

#   # Order Items and Orders routes
#   resources :order_items, only: [:create, :destroy]
#   resources :orders, except: [:edit]

#   # Products and Categories routes
#   resources :products, except: [:edit] do
#     collection do
#       get 'new', to: 'products#create', as: 'new_product'
#       post 'create_product', to: 'products#create', as: 'create_product'
#     end
#   end

#   resources :categories, except: [:edit] do
#     member do
#       get 'products', to: 'categories#products_by_category'
#     end
#   end
#   post 'create_product', to: 'products#create', as: 'create_product'

#   # Authentication routes using Devise Token Auth

#   #getcurrentuser
#   get '/current_user', to: 'application#index', as: 'current_user'


#   mount_devise_token_auth_for 'User', at: 'auth', controllers: {
#     registrations: 'auth/registrations'
#   }
#   # devise_for :users

 

  

# end
Rails.application.routes.draw do
  # Receipts and Addresses routes
  resources :receipts, only: [:create]
  resources :addresses, except: [:edit]

  # Authentication routes using Devise Token Auth
  namespace :auth do
    devise_scope :user do
      get 'registrations/show', to: 'registrations#show'
      resources :registrations, only: [:index] # Route for fetching all users
      get 'users', to: 'registrations#index'

    end
  end
  
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }

  # Products routes
  resources :products, except: [:edit] do
    collection do
      get 'on_offer', to: 'products#on_offer'
      get 'recently_added', to: 'products#recently_added'
      get 'new', to: 'products#create', as: 'new_product'
      post 'create_product', to: 'products#create', as: 'create_product'
      get 'products/by_category/:category_id', to: 'products#by_category'

    end
  end

  # Categories routes
  resources :categories, except: [:edit] do
    member do
      get 'products', to: 'categories#products_by_category'
    end
  end

  # Cart routes
  get '/cart', to: 'carts#show', as: 'cart'
  resources :carts, only: [:show, :update, :destroy, :create] do
    member do
      post 'add_to_cart', to: 'carts#add_to_cart'
      patch 'add_quantity/:order_item_id', to: 'carts#add_quantity', as: :add_quantity

      # patch 'add_quantity/:product_id', to: 'carts#add_quantity', as: :add_quantity
      delete 'remove_item/:order_item_id', to: 'carts#remove_item', as: :remove_item
      # delete 'remove_item/:id', to: 'carts#remove_item', as: :remove_item
      delete 'clear_cart', to: 'carts#clear_cart', as: :clear_cart
      get 'get_cart'
    end
  end

  # Order Items and Orders routes
  get '/orders/total_revenue', to: 'orders#total_revenue'

  resources :order_items, only: [:create, :destroy]
  resources :orders, except: [:edit]
  resources :orders, only: [:index] # Route for fetching all orders
  get ' /order_history', to: 'orders#order_history'
  put '/orders/:id/close', to: 'orders#close', as: 'close_order'





  # Current user route
  get '/current_user', to: 'application#index', as: 'current_user'

  # Mount ActionCable
  mount ActionCable.server => '/cable'
end
