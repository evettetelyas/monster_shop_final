Rails.application.routes.draw do
  get 'password_resets/new'

  root to: 'welcome#home'
  get '/', to: 'welcome#home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:create, :new] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  patch '/cart/apply_coupon', to: 'cart#apply_coupon'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'

  resources :orders, only: [:new, :create]
  patch '/orders/:id/cancel', to: 'orders#cancel', as: :order_cancel
  patch '/orders/:id/update_address', to: 'orders#update_address', as: :order_update
  get '/orders/:order_id', to: 'orders#show', as: :order
  patch '/orders/:order_id/ship', to: 'orders#ship', as: :shipped_order
  get '/profile/orders/:order_id', to: 'orders#show'
  get '/profile/orders', to: 'orders#index'

  resources :users, only: [:create]
  get '/register', to: 'users#new'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile/edit', to: 'users#update'
  get '/profile/edit_password', to: 'users#edit_password'
  patch '/profile/edit_password', to: 'users#update_password'

  get '/profile/addresses', to: 'addresses#index'
  delete '/profile/addresses/:id', to: 'addresses#destroy', as: :delete_address
  get '/profile/addresses/new', to: 'addresses#new', as: :new_address
  get '/profile/addresses/:id', to: 'addresses#show', as: :address_show
  post '/profile/addresses', to: 'addresses#create'
  patch '/profile/addresses/:id', to: 'addresses#update'
  get '/profile/addresses/:id/edit', to: 'addresses#edit', as: :edit_address

  namespace :merchant do
    resource :items, only: [:new, :create]
    resource :coupons, except: [:show]
  end

  get '/merchant', to: 'merchant/dashboard#index', as: :merchant_dash
  get '/merchant/items', to: 'merchant/dashboard#items'
  patch '/merchant/coupons/:id/activity', to: 'merchant/coupons#change_status', as: :coupon_update_activity
  get '/merchant/items/:id/edit', to: 'merchant/items#edit', as: :merchant_edit_item
  patch '/merchant/items/:id/activity', to: 'merchant/items#update_activity', as: :merchant_update_item_activity
  patch '/merchant/items/:id', to: 'merchant/items#update', as: :merchant_update_item
  delete '/merchant/items/:id', to: 'merchant/items#destroy', as: :merchant_delete_item
  get '/merchant/orders/:id', to: 'merchant/dashboard#order_show', as: :merchant_order_show
  post '/merchant/orders/:order_id/items/:item_id', to: 'merchant/items#fulfill_item', as: :merchant_fulfill_item

  namespace :admin do
    resources :users, only: [:index]
    resources :merchants, only: [:update]
  end

  get '/admin', to: 'admin/dashboard#index', as: :admin_dash
  get '/admin/users/:id', to: 'users#show'
  get '/admin/merchants/:id', to: 'admin/merchants#index'
  get '/admin/users/:user_id/orders/:order_id', to: 'orders#show'

  resources :password_resets

  match "*path", to: "welcome#catch_404", via: :all
end
