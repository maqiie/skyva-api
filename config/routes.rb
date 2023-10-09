# Rails.application.routes.draw do
#   get 'receipts/create'
#   get 'addresses/index'
#   get 'addresses/show'
#   get 'addresses/new'
#   get 'addresses/create'
#   get 'addresses/edit'
#   get 'addresses/update'
#   get 'addresses/destroy'
#   get 'carts/show'
#   get 'carts/update'
#   get 'carts/destroy'
#   get 'order_items/create'
#   get 'order_items/destroy'
#   get 'orders/index'
#   get 'orders/show'
#   get 'orders/new'
#   get 'orders/create'
#   get 'orders/edit'
#   get 'orders/update'
#   get 'orders/destroy'
#   get 'products/index'
#   get 'products/show'
#   get 'products/new'
#   get 'products/create'
#   get 'products/edit'
#   get 'products/update'
#   get 'products/destroy'
#   get 'categories/index'
#   get 'categories/show'
#   get 'categories/new'
#   get 'categories/create'
#   get 'categories/edit'
#   get 'categories/update'
#   get 'categories/destroy'
#   # <===============sign in and login =======================>
#   mount_devise_token_auth_for 'User', at: 'auth', controllers: {
#     registrations: 'auth/registrations'
#   }

#   # <=============Custom route for creating a new produc============================>
#    get 'products/new', to: 'products#create', as: 'new_product'
#   post 'create_product', to: 'products#create', as: 'create_product'

#   # <=============cart routes================>
#   resources :carts, only: [:show, :update, :destroy, :create]
#   post '/add_to_cart', to: 'carts#add_to_cart'
#   patch 'add_quantity/:product_id', to: 'carts#add_quantity', as: :add_quantity
#   delete 'remove_item/:product_id', to: 'carts#remove_item', as: :remove_item
#   delete 'clear_cart', to: 'carts#clear_cart', as: :clear_cart
#   get '/cart', to: 'carts#show', as: 'cart'
    

# # <================categories==============================>
#   resources :categories do
#     # /categories/:id/products, where :id is the ID of the category you want to retrieve products for.
#     get 'products', on: :member, to: 'categories#products_by_category'
#   end
# end


Rails.application.routes.draw do
  # Receipts and Addresses routes
  resources :receipts, only: [:create]
  resources :addresses, except: [:edit]

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

  # Authentication routes using Devise Token Auth
 

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }
  # devise_for :users
  
end
