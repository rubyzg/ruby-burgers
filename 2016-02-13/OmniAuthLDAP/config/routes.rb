Rails.application.routes.draw do

  # OmniAuth special events
  match '/auth/failure',  to: 'sessions#auth_failure', via: [:get, :post]
  match '/auth/sign_out', to: 'sessions#destroy',      via: [:get, :delete], as: :sign_out

  # OmniAuth provider callback
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post], as: :auth_callback

  # OmniAuth Sign In with configured provider strategy, e.g. auth_path('ldap')
  get '/auth/:provider', to: -> env { [404, {}, ["Not Found"]] }, as: :auth

  root 'home#index'
end
