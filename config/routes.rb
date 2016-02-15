Myapp::Application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#create_fb'
  get 'logout', to: 'sessions#destroy'


  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "sign_up" => "users#new", :as => "sign_up"
  root :to => "sessions#new"
  resources :users do
    post :update_row_order, on: :collection
     post :sort, on: :collection
    member do
      get :confirm_email
    end
  end

  resources :sessions
end
