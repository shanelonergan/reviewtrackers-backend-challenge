require "rails_helper"

RSpec.describe "review API", :type => :request do

  describe "collect_reviews" do
    it "returns a list of reviews from a valid lendingtree url" do
      expect(response.status).to eq 400
    end

    it "returns an error for an invalid lendingtree url" do
      post "/collect_reviews", params: {url: "https://www.lendingtree.com/reviews/"}
      json_response = JSON.parse(response.body)
      expect(json_response).to eq "error" => "Must be a valid lendingtree URL"
      expect(response.status).to eq 422
    end
  end
end
