require 'nokogiri'
require 'open-uri'

class Scraper
  BASE_URL = "www.lendingtree.com/reviews"
  REVIEW_CSS_TAG = ".col-xs-12.mainReviews"

  attr_accessor :error

  def initialize(url_params)
    @url = url_params[:url]
    @page_limit = url_params[:page_limit]&.to_i
    @business_id = url_params[:url]&.split('/')&.last&.to_i
    @error
  end

  def valid?
    url_regex = Regexp.new('https://www\\.lendingtree\\.com/reviews/business/.*/[0-9]+', Regexp::IGNORECASE)

    if @url.blank?
      @error = 'Must include URL'
    elsif !valid_url?
      @error = 'Invalid URL'
    elsif !@url.match(url_regex)
      @error = "Must use valid lendingtree URL"
    end
    @error.nil?
  end

  def valid_url?
    uri = URI.parse(@url)
    uri.host.present?
  rescue URI::InvalidURIError
      false
  end

  def scrape_from_url(url)
    Nokogiri::HTML(URI.open(url))
  end

  def scrape_page(page_number)
    return scrape_from_url(@url) if page_number == 1

    url_with_page = "#{@url}?sort=&pid=#{page_number}"

    scrape_from_url(url_with_page)
  end

  def get_reviews
    begin

      # determine number of reviews on the current page
      # determine number of total reviews (can be found in hidden html element), calculate number of total pages
      # loop from first to last page
      # Scrape what you need, create a Review with relevant data

      page_number = 1
      reviews_per_page = 10 # I believe this is a constant

      total_reviews = self.scrape_page(page_number).css(".start-rating-reviews").css(".hidden-xs").text.split[0].to_i
      total_pages = (total_reviews.to_f / reviews_per_page).round

      while page_number <= (@page_limit || total_pages)
        reviews = self.scrape_page(page_number).css(REVIEW_CSS_TAG)
        reviews.each do |review|
          closed_with_lender = review.css(".yes").text.to_s.empty? ? false : true

          Review.create(
            title: review.css(".reviewTitle").text,
            content: review.css(".reviewText").text,
            author: review.css('p.consumerName').text.strip.split.join(" "),
            rating: review.css('div.numRec').text.strip.delete("()").split('of').first.to_i,
            date: review.css(".consumerReviewDate").text,
            closed: closed_with_lender,
            loan_type: review.css(".loanType")[0].text || '',
            review_type: review.css(".loanType")[1].text || '',
            business_id: @business_id
          )
        end

        page_number += 1
      end

    rescue => error
      @error = 'Something went wrong. Please check your URL and try again'
    else
      Review.all.where(business_id: @business_id)
    end
  end
end
