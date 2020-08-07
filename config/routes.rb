Rails.application.routes.draw do
  

  get 'messages/index'
  get 'messages/create'
  get 'messages/destroy'
  get 'relationships/create'
  get 'relationships/destroy'
  root to: 'homes#top'
  
  get 'home/about', to: 'homes#about'

  get 'search', to: 'search#search'

  devise_for :users

  resources :users do
    resources :messages, only: [:index, :create, :destroy]
    resource :relationships, only: [:create, :destroy]
    member do
      get :follows
      get :followers
    end
  end 

 resources :books, except: [:new] do
  resource :favorites, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
 end

end
