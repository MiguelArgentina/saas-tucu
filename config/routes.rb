Rails.application.routes.draw do
  
  
  devise_for :users
  get 'home/index'
  root to: 'home#index'
  
  resources :users, only: [:index, :show] do
    member do
      patch :resend_invite
    end
    
  end
  
  resources :tenants do
    get :my, on: :collection
  end
  
  resources :members do
    get :invite, on: :collection
  end
  
end
