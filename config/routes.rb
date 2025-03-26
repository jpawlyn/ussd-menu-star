Rails.application.routes.draw do
  mount_avo at: "/"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "/ussd_callback/:country_code/:short_name", controller: "ussd_callback", action: :create
end
