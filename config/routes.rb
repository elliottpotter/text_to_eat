Rails.application.routes.draw do

  get  'users/create',   to: 'users#create'
  post 'queries/create', to: 'queries#create'
  post 'cookies/create', to: 'cookies#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
