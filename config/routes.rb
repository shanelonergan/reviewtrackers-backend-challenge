Rails.application.routes.draw do
  resources :reviews, only: [:create]
  post "/scrape_reviews", to: "reviews#scrape_reviews"
end
