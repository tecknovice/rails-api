Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API Routes
  namespace :api do
    # Authentication routes
    post 'register', to: 'authentication#register'
    post 'login', to: 'authentication#login'
    
    # User profile routes
    get 'profile', to: 'profile#show'
    put 'profile', to: 'profile#update'
    
    # Admin routes
    namespace :admin do
      resources :users, only: [:index, :show, :update, :destroy]
    end
  end
end
