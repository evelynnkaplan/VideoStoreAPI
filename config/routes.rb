Rails.application.routes.draw do
  resources :customers, except: [:edit, :new]
end
