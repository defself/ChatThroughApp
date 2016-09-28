Rails.application.routes.draw do
  devise_for :users

  get :oauth, to: "oauths#authorize"
  resources :users,      only: [:index]
  resources :chat_rooms, only: [:create]
  post   "/bots", to: "bots#create",  as: :wake_up_bots
  delete "/bots", to: "bots#destroy", as: :kill_bots

  root "users#index"
end
