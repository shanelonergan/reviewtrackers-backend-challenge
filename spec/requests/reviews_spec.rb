require "rails_helper"

RSpec.describe "review API", :type => :request do

  describe "collect_reviews" do
    it "returns a list of reviews from a valid lendingtree url" do
      post "/scrape_reviews", params: {url: "https://www.lendingtree.com/reviews/business/ondeck/51886298"}
      json_response = JSON.parse(response.body)
      puts json_response
      expect(response.status).to eq 201
    end

    it "returns an error for an invalid lendingtree url" do
      post "/scrape_reviews", params: {url: "https://www.lendingtree.com/reviews/"}
      json_response = JSON.parse(response.body)
      expect(json_response).to eq "error" => "Must be a valid lendingtree URL"
      expect(response.status).to eq 422
    end

    it "returns an error for an invalid url" do
      post "/scrape_reviews", params: {url: "https://google.com"}
      json_response = JSON.parse(response.body)
      expect(json_response).to eq "error" => "Must use lendingtree URL"
      expect(response.status).to eq 422
    end
  end
end
