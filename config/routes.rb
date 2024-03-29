Rails.application.routes.draw do
   
   devise_for :users, :controllers => {:sessions => "users/sessions", :passwords => "users/passwords", :registrations => "users/registrations"}

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/about-us' => 'home#about_us'
  get '/contact' => 'home#contact'
  get '/blogs' => 'home#blogs'
  get '/dashboard' => 'dashboard#index'
end
