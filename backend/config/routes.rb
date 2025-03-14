Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # API routes
  namespace :api do
    namespace :v1 do
      # ユーザー認証
      post 'login', to: 'users#login'
      post 'signup', to: 'users#create'
      get 'me', to: 'users#me'
      
      # ユーザー管理
      resources :users
      
      # プロフィール管理
      resources :candidate_profiles do
        collection do
          get 'me', to: 'candidate_profiles#me'
        end
      end
      
      resources :company_profiles do
        collection do
          get 'me', to: 'company_profiles#me'
        end
      end
      
      # インターンシップ管理
      resources :internships
      
      # スカウト管理
      resources :scouts do
        member do
          post 'respond', to: 'scouts#respond'
        end
      end
      
      # 応募管理
      resources :applications do
        member do
          patch 'review', to: 'applications#review'
          patch 'accept', to: 'applications#accept'
          patch 'reject', to: 'applications#reject'
        end
      end
    end
  end
  
  # フロントエンドへのフォールバック
  # get '*path', to: 'application#frontend_index_html', constraints: lambda { |req|
  #   req.path.exclude? 'rails/active_storage' and req.path.exclude? 'api/'
  # }
end
