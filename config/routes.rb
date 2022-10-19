Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # get '/api/v1/merchants/:id/items', to: 'merchant_items#index'
      get "/merchants/find", to: "merchants#find"
      get "/merchants/find_all", to: "merchants#find_all"
      get "/items/find_all", to: "items#find_all"
      get "/items/find", to: "items#find"
      resources :items, only: [:index, :show, :create, :edit, :update, :destroy] do
        resource :merchant, only: [:show], :controller => 'item_merchant' 
      end

      resources :merchants, only: [:index, :show] do
        resource :items, controller: 'merchant_items'
      end
    end
  end
end