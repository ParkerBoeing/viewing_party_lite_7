Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"
  root "welcome#index"
  
  resources :users do
    get "discover", on: :member
    get "movies", to: "discover_movies#index"
    get "movies/:movie_id", to: "movie_details#show"
    get "movies/:movie_id/viewing-party/new", to: "viewing_parties#new"
    post "movies/:movie_id/viewing-parties", to: "viewing_parties#create"
    post "movies/:movie_id/viewing-parties/:viewing_party_id/user-viewing-parties", to: "user_viewing_parties#create"
  end

  get "/register", to: "users#new"
  get "/login", to: "users#login_form"
  post "/login", to: "users#login"
  get "/logout", to: "users#logout"
end
