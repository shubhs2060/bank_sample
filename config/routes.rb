Rails.application.routes.draw do
  resources :operations
  devise_for :users
  root to: "operations#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
