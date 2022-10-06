Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'news#home'
  # root 'equities#check'
  
  
  get '/search', to: 'news#search'
  get '/account', to: 'users#account'
  get '/headlines', to: 'news#headlines'
  
  get '/chart', to: 'equities#chart'
  
  post '/equities/create', to: 'equities#create'
  get '/equities', to: 'equities#search'
  delete '/equities/:ticker', to: 'equities#destroy' 

  get '/news/wiki', to: 'news#wiki'
  get '/login', to: 'sessions#new'
  get '/signup', to: 'users#new'

  resources :users, only: [:show, :create]
  resource :session, only: [:create, :destroy]
  resources :bookmarks, only: [ :create, :destroy, :update]
  get '*path', to: 'news#home'
end
