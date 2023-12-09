Rails.application.routes.draw do
  root 'forums#index'
 # resources :users
  resources :forums do
    resources :posts, shallow: true
    resources :subscriptions, shallow: true, except: [:index]
  end
  get '/subscriptions', to: 'subscriptions#index', as: 'subscriptions'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/users', to: 'users#index', as: 'users'
  get '/users/new', to: 'users#new', as: 'new_user'
  get '/users/:id', to: 'users#show', as: 'user'
  get '/users/:id/edit', to: 'users#edit', as: 'edit_user'
  post '/users', to: 'users#create'
  patch '/users/:id', to: 'users#update'  
  delete '/users/logoff', to: 'users#logoff', as: 'user_logoff'
  delete '/users/:id', to: 'users#delete'
  post '/users/:id/logon', to: 'users#logon', as: 'user_logon'
end
