Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :tournaments, only: [:index]
  end

  devise_for :users, path: "", skip: [:session, :api]

  devise_scope :user do
    namespace :devise, path: "" do
      namespace :api do
        resource :tokens, only: [] do
          collection do
            post :revoke, as: :revoke
            post :refresh, as: :refresh
            post :login, action: :sign_in, as: :login
            get :info, as: :info
          end
        end
      end
    end
  end
end
