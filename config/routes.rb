Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "events#index"

  devise_for :users

  get "documentation", to: "documentation#index"

  resources :events, only: [ :show ] do
    get "subscribed", on: :collection

    member do
      post :toggle_subscription
      get :weather
    end
  end

  namespace :api do
    resources :events
  end
end
