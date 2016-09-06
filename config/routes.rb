require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :items, only: [:index, :show]
  resources :characters, only: [:index, :show]
  resources :guilds, only: [:index, :show]
  resources :auctions, only: [:index, :show]
end
