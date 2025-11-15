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

  namespace :conf do
    namespace :api do
      namespace :tts do
      post "/", to: "tts#create"
      end
    end
  end

  post 'api/contato', to: 'contato#create'

  get "up" => "rails/health#show", as: :rails_health_check
end
