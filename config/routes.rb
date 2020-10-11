Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  resources :tweets do
    post 'likes', to: 'tweets#likes'
    post 'retweet', to: 'tweets#retweet'
    get 'detail', to: 'tweets#detail'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  post 'follow/:user_id', to: 'users#follow', as: 'users_follow'
  get 'home/index'
  get 'all_tweets', to: 'home#all_tweets', as: 'all_tweets'
  get 'home/profile'

  root 'home#index'

  #rutas api
  resources :api, path: '/api/news'
  get '/api/:date1/:date2' => 'dates#show'
  get '/api/create' => 'api#create'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
