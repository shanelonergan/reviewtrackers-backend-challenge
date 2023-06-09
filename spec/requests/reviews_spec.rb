require "rails_helper"

RSpec.describe "review API", :type => :request do

  describe "scrape_reviews" do
    it "returns a list of reviews from a valid lendingtree url" do
      post "/scrape_reviews", params: {url: "https://www.lendingtree.com/reviews/business/ondeck/51886298"}
      json_response = JSON.parse(response.body)
      first_review = json_response.first

      expect(response.status).to eq 201
      # byebug
      expect(first_review.keys).to eq ["id", "title", "content", "author", "rating", "date", "closed", "loan_type", "review_type", "created_at", "updated_at", "business_id"]
      expect(json_response.count).to be > 600
    end

    it "accepts a page_limit param which limits the number of pages scraped during the request" do
      post "/scrape_reviews", params: {url: "https://www.lendingtree.com/reviews/business/ondeck/51886298", page_limit: 1}
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 201
      expect(json_response.count).to eq 10
    end

    it "returns an error for an invalid lendingtree url" do
      post "/scrape_reviews", params: {url: "https://www.lendingtree.com/reviews/"}
      json_response = JSON.parse(response.body)
      expect(json_response).to eq "error" => "Something went wrong. Please check your URL and try again"
      expect(response.status).to eq 422
    end

    it "returns an error for an non-lendingtree url" do
      post "/scrape_reviews", params: {url: "https://google.com"}
      json_response = JSON.parse(response.body)
      expect(json_response).to eq "error" => "Must use lendingtree URL"
      expect(response.status).to eq 400
    end

    it "returns an error for an invalid url" do
      post "/scrape_reviews", params: {url: "test"}
      json_response = JSON.parse(response.body)
      expect(json_response).to eq "error" => "Invalid URL"
      expect(response.status).to eq 400
    end

    it "returns an error for request with no url" do
      post "/scrape_reviews"
      json_response = JSON.parse(response.body)
      expect(json_response).to eq "error" => "Must include URL"
      expect(response.status).to eq 400
    end
  end
end
