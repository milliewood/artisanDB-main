Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :api_keys, only: [:create]
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
    end
  end
    namespace :api do
      namespace :v1 do
        resources :databases do
          post 'upload_file', on: :member
        end
      end
    end
end
