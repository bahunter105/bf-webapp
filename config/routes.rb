Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#coming_soon'
  get 'home', to: 'pages#home'
  get 'families', to: 'pages#family_home'
  get 'home/educators', to: 'pages#educator_home'
  get 'webinar', to: 'pages#webinar'
  get 'courses', to: 'pages#courses'
  get 'ambassador/family', to: 'pages#ambassador_family'
  get 'ambassador/educators', to: 'pages#ambassador_educator'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact_us'
  get 'consultations', to: 'pages#consultations'
  get 'GWM', to: 'pages#grow_with_me'

  get 'workshops', to: 'workshops#workshops'
  get "workshops/:id", to: "workshops#show"


end
