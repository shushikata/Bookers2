Rails.application.routes.draw do
  
 root to: 'homes#top'
 
 get 'home/about', to: 'homes#about'

 devise_for :users

 resources :users, except: [:new, :destroy]

 resources :books, except: [:new] do
  resource :favorites, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
 end
 
end
