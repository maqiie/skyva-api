Rails.application.routes.draw do
  get 'receipts/create'
  get 'addresses/index'
  get 'addresses/show'
  get 'addresses/new'
  get 'addresses/create'
  get 'addresses/edit'
  get 'addresses/update'
  get 'addresses/destroy'
  get 'carts/show'
  get 'carts/update'
  get 'carts/destroy'
  get 'order_items/create'
  get 'order_items/destroy'
  get 'orders/index'
  get 'orders/show'
  get 'orders/new'
  get 'orders/create'
  get 'orders/edit'
  get 'orders/update'
  get 'orders/destroy'
  get 'products/index'
  get 'products/show'
  get 'products/new'
  get 'products/create'
  get 'products/edit'
  get 'products/update'
  get 'products/destroy'
  get 'categories/index'
  get 'categories/show'
  get 'categories/new'
  get 'categories/create'
  get 'categories/edit'
  get 'categories/update'
  get 'categories/destroy'
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }
  # Custom route for creating a new product
  get 'products/new', to: 'products#create', as: 'new_product'
  # post 'products', to: 'products#create', as: 'create_product'
  post 'create_product', to: 'products#create', as: 'create_product'



  # Other routes 
  resources :carts, only: [:show, :update, :destroy, :create]
  post '/add_to_cart', to: 'carts#add_to_cart'

end
