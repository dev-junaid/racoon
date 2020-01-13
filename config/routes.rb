require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do
  resources :orders
  resources :customers
  resources :notifications
  mount Sidekiq::Web => '/sidekiq'
  mount API => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
