Rails.application.routes.draw do
  

  get 'relationships/create'
  get 'relationships/destroy'
 root to: 'homes#top'
 
 get 'home/about', to: 'homes#about'

 get 'search', to: 'search#search'

 devise_for :users

 resources :users do
  resource :relationships, only: [:create, :destroy]
  get :follows, on: :member 
  get :followers, on: :member
 end 

 resources :books, except: [:new] do
  resource :favorites, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
 end

end
