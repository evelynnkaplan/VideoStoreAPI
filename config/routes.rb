Rails.application.routes.draw do
  resources :customers, except: [:edit, :new]
  resources :movies, except: [:edit, :new]
  post "/rentals/check-out", to: "customer_movies#checkout", as: "checkout"
  post "/rentals/check-in", to: "customer_movies#checkin", as: "checkin"
end
