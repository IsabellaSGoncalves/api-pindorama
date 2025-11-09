Rails.application.routes.draw do
  resources :eventos
  resources :artigos
  resources :autors
  resources :imagens
  resources :global_settings

  namespace :login do
    namespace :api do
      post "administradores", to: "administradores#autenticar"
    end
  end

  namespace :login do
    namespace :api do
      get "administradores", to: "administradores#sessao"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
