class ReviewsController < ApplicationController
  def index
    reviews = Review.all
    render json: reviews
  end

  def show
    review = find_review
    render json: review
  end

  def create
    review = Review.create!(review_params)
    render json: review, status: :created
  rescue ActiveRecord::RecordInvalid => invalid
    render json: {error: "Invalid review parameters"}, status: 422
  end

  def update
    review = find_review
    review.update(review_params)
    render json: review
  end

  def scrape_reviews
    scraper = Scraper.new(url_params)
    reviews = scraper.get_reviews
  end

  private

  def find_review
    Review.find(params[:id])
  end

  def url_params
    params.permit(:url)
  end

  def review_params
    params.permit(:title, :content, :author, :rating, :date, :closed, :loantype, :reviewtype, :url)
  end
end