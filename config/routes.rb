Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # get '/api/v1/merchants/:id/items', to: 'merchant_items#index'
      get "/merchants/find", to: "merchants#find"
      resources :items, only: [:index, :show, :create, :edit, :update, :destroy] do
        resources :merchant, controller: 'merchants', only: [:show]
      end
      resources :merchants, only: [:index, :show] do
        resources :items, controller: 'merchant_items'
      end
    end
  end
end
