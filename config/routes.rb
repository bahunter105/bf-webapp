Rails.application.routes.draw do
  mount ::Caffeinate::Engine => '/caffeinate'

  get 'cookies/index'
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
  get 'account', to: 'pages#account'

  get 'cookies', to: 'cookies#index'

  resources :bookmarks, only: [:index, :show, :destroy]
  post 'bookmarks', to: 'bookmarks#create'

  resources :workshops, only: [:show] do
    member do
      get :preview
    end
  end

  get 'workshops', to: 'workshops#workshops'
  post "workshops/add_to_cart/:id", to: "workshops#add_to_cart", as: "add_to_cart"
  post "workshops/add_to_cart_ws_page/:id", to: "workshops#add_to_cart_ws_page", as: "add_to_cart_ws_page"
  delete "workshops/remove_from_cart/:id", to: "workshops#remove_from_cart", as: "remove_from_cart"
  delete 'workshops/remove_from_cart_cart_page/:id', to:'workshops#remove_from_cart_cart_page', as: "remove_from_cart_cart_page"

  get 'create_shopping_cart_order', to: 'orders#create_shopping_cart_order'
  get 'create_consult_order', to: 'orders#create_consult_order'

  resources :orders, only: [:show, :create] do
      resources :payments, only: :new
  end

  resources :consultations

  get 'cart', to: 'cart#cart'

  mount StripeEvent::Engine, at: '/stripe-webhooks'

end
