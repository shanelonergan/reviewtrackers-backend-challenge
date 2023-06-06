Rails.application.routes.draw do
  resources :reviews
  post "/scrape_reviews", to: "reviews#scrape_reviews"
end
