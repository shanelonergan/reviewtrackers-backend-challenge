require 'nokogiri'
require 'open-uri'

class Scraper
  BASE_URL = "www.lendingtree.com/reviews"
  REVIEW_CSS_TAG = ".col-xs-12.mainReviews"

  attr_accessor :error

  def initialize(url_params)
    @url = url_params[:url]
    @business_id = url_params[:url]&.split('/')&.last&.to_i
    @error
  end

  def valid?
    if !@url.include?(BASE_URL)
      @error = "Must use lendingtree URL"
    elsif !@business_id
      @error = "Incomplete lendingtree URL"
    end

    @error.nil?
  end

  def scrape_from_url(url)
    begin
      Nokogiri::HTML(URI.open(url))
    rescue OpenURI::HTTPError => error
      if error.message == '404 Not Found'
        @error = error.message
      else
        raise error
      end
    end
  end

  def scrape_page(page_number)
    return scrape_from_url(@url) if page_number == 1

    url_with_page = "#{@url}?sort=&pid=#{page_number}"

    scrape_from_url(url_with_page)
  end

  def get_reviews
    begin

      # determine number of reviews on the current page (is this a fixed max number?)
      # determine number of total reviews (can be found in hidden html element), calculate number of total pages
      # loop from first to last page
      # Scrape what you need, create a Review with relevant data

      page_number = 1
      scraped_reviews = self.scrape_page(page_number).css(REVIEW_CSS_TAG)

      # max number of reviews per page
      reviews_per_page = scraped_reviews.count # is this always 10?

      total_reviews = self.scrape_page(page_number).css(".start-rating-reviews").css(".hidden-xs").text.split[0].to_i

      total_pages = (total_reviews.to_f / reviews_per_page).round
      # byebug

      # until page_number == total_pages
        reviews = self.scrape_page(page_number).css(REVIEW_CSS_TAG)
        reviews.each do |review|
          closed_with_lender = review.css(".yes").text.to_s.empty? ? false : true

          Review.create(
            title: review.css(".reviewTitle").text,
            content: review.css(".reviewText").text,
            author: review.css('p.consumerName').text.strip.split.join(" "),
            rating: review.css('div.numRec').text.strip.delete("()").split('of').first,
            date: review.css(".consumerReviewDate").text,
            closed: closed_with_lender,
            loan_type: review.css(".loanType")[0].text || '',
            review_type: review.css(".loanType")[1].text || '',
            business_id: @business_id
          )
        end

        # page_number += 1
      # end

    rescue => error
      puts error
      @error = 'Something went wrong'
    else
      Review.all.where(business_id: @business_id)
    end
  end
end
