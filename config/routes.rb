Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :session
  resources :passwords, param: :token
  mount_avo at: "/"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "/ussd/callback/:country_code/:short_name", controller: "ussd", action: :callback, as: "ussd_callback"
end
