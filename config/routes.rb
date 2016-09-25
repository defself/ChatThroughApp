Rails.application.routes.draw do
  devise_for :users

  resources :users
  resource :oauth, only: [:show]

  root "home#welcome"
end
