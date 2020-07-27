Rails.application.routes.draw do
  
 root to: 'homes#top'
 
 get 'home/about', to: 'homes#about'

 devise_for :users

 resources :users, except: [:new, :destroy]
 resources :books, except: [:new]
end
