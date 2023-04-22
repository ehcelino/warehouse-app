Rails.application.routes.draw do
  root 'home#index'
  resources :warehouses, only: [:show, :new, :create, :edit, :update]
end
