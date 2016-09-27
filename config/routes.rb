Rails.application.routes.draw do
  devise_for :users

  resources :users,      only: [:index]
  resources :chat_rooms, only: [:create]
  get :oauth, to: "oauths#authorize"

  root "users#index"
end
