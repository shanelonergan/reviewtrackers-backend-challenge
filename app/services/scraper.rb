require 'nokogiri'
require 'open-uri'

class Scraper
  BASE_URL = "www.lendingtree.com/reviews"

  def initialize(url)
    @url = url
  end

  def scrape_from_url(url)
    Nokgiri::HTML(URI.open(url))
  end

  def scrape_page(page_number)
    return scrape_from_url(@url) if page_number == 1

    url_with_page = "#{@url}?sort=&pid=#{page_number}"

    scrape_from_url(url_with_page)
  end

  def get_reviews
    begin

    # determine number of reviews on the current page (is this a fixed max number?)
    # determine number of total reviews, number of total pages
    # loop from first to last page
    # Scrape what you need
    page_number = 1
    scraped_reviews = self.scrape_page(page_number)
    byebug

    rescue => error
      puts error
    end
  end
end
