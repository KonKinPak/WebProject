Rails.application.routes.draw do
  resources :comments
  resources :users
  resources :posts
  resources :rooms do
    resources :messages
  end
  get '',to:'users#feed'
  get 'main' ,to: 'users#main'
  post 'main', to: 'users#login'
  get 'register',to: 'users#new'
  get 'feed' ,to: 'users#feed'
  get '/post', to:'posts#create'
  #profile
  get '/profile/:nickname', to: 'users#profile', as: "profile_user"
  post '/profile/:nickname/follow', to: 'users#follow' ,as: "follow_user"
  post '/profile/:nickname/unfollow', to: 'users#unfollow' ,as: "unfollow_user"

  #Admin
  post '/users/:id/approve', to: 'users#approve',as: "approve_user"
  post '/users/:id/ban', to: 'users#ban',as: "ban_user"
  post '/users/:id/unban', to: 'users#unban',as: "unban_user"

  #Like
  post 'post/:post_id/like', to: 'posts#like', as: "like_post"
  post 'post/:post_id/unlike', to: 'posts#unlike',as: "unlike_post"
  post 'comment/:comment_id/like', to: 'comments#like', as: "like_comment"
  post 'comment/:comment_id/unlike', to: 'comments#unlike',as: "unlike_comment"

  #chat
  get '/chat', to: 'rooms#index'
  get '/chat/:id',to: 'chats#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
