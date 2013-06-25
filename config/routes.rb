WHM::Application.routes.draw do

  resources :homes, only: [:index] do
    collection do
      get 'logout'
    end
  end

  resources :dns_records, except: [:show, :edit, :update] do
    member do
      get 'check_state'
    end
  end

  resources :nginx_sites, except: [:show, :edit, :update] do
    member do
      get 'check_state'
    end
  end

  resources :sftp_users, except: [:show, :edit, :update] do
    member do
      get 'check_state'
    end
  end

  resources :servers, except: [:show, :edit, :update] do
    member do
      get 'check_state'
    end
  end

  root :to => 'homes#index'
end