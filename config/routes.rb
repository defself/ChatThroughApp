Rails.application.routes.draw do
  devise_for :users

  get :oauth, to: "oauths#authorize"
  resources :users,      only: [:index]
  resources :chat_rooms, only: [:create]
  resources :bots,       only: [:create]

  root "users#index"
end
