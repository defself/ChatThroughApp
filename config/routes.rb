Rails.application.routes.draw do
  devise_for :users

  resources :users,      only: [:index]
  resources :chat_rooms, only: [:create]
  resource  :oauth,      only: [:show, :create]

  root "users#index"
end
