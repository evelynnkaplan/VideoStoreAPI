Rails.application.routes.draw do
  resources :customers, except: [:edit, :new]
  resources :movies, except: [:edit, :new]
end
