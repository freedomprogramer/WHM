WHM::Application.routes.draw do

  resources :homes

  resources :dns_records

  resources :nginx_sites

  resources :sftp_users

  resources :servers, except: [:show, :edit, :update]

  root :to => 'homes#index'
  
end