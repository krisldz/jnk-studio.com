Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Publiczne JSON API dla frontu (SvelteKit). Tylko odczyt.
  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index show], param: :slug
      # Formularz kontaktowy i strony dołączą w kolejnych etapach:
      # resources :inquiries, only: :create
      # resources :pages, only: :show, param: :key
    end
  end

  # Uwierzytelnianie panelu — pod /admin (Caddy kieruje /admin do Rails).
  scope "/admin" do
    resource :session, only: %i[new create destroy]
    resources :passwords, param: :token, only: %i[new create edit update]
  end

  # Panel CMS (Hotwire) pod /admin.
  namespace :admin do
    root "dashboard#index"
    resources :projects do
      member { patch :publish }
    end
    resources :categories, except: :show
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
