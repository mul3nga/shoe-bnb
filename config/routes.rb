Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  # created routes should be checked with rails routes in terminal
  # before controller actions are created.
  resources :shoes do
    resources :bookings, only: %i[new create]
  end

  # allows us to show the user their individual bookings.
  resources :bookings, only: %i[index destroy]

  get "/my_shoes", to: "shoes#my_shoes"
end
