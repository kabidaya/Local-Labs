LocalLabs::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  resources :users do
    resources :permissions
  end
  get "/url_details", to: 'users#url_details'
  get "/manage_views", to: 'pages#manage_views'
  get "/url_dashboard", to: 'views#url_dashboard'
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :accounts do
    resources :views
  end

  resources :views do
    member do
      get "/twitter_profile", to: 'views#twitter_profile'
      get "/dashboard", to: 'views#dashboard'
      get "/mentions", to: 'views#mentions'
      get "/daily_view_metrics", to: 'views#daily_view_metrics'
    end
  end
end

