# README

## ReviewTrackers Take Home Code Challenge

### Instructions

This is a API designed to accept a URL from lendingtree.com such as `https://www.lendingtree.com/reviews/business/ondeck/51886298`, and return a list of all reviews for the given business. This can be a large number depending on the business, and the default behavior is to return all reviews. It also accepts an optional parameter of `page_limit` to reduce the number of reviews that will be returned to a given number of pages (pagination determined by the website itself).

#### Request Format

```json
{
	"url": "https://www.lendingtree.com/reviews/business/fundbox-inc/111943337",
	"page_limit": 2
}
```

1. Clone repository
2. `bundle install` to install necessary dependencies
3. `rails db:create` to create your SQLite database
4. `rails db:migrate` to run migrations
5. `rspec` to run the test suite
6. `rails s` to start a local server

### Requirements

1. Please write in ruby or python
2. Use this website: https://www.lendingtree.com/reviews/business
3. Write a web service that accepts requests of 'business' URLs (i.e. https://www.lendingtree.com/reviews/business/ondeck/51886298)
4. This service should collect all 'reviews' on the URL defined
5. The response should consist of: title of the review, the content of review, author, star rating, date of review, and any other info you think would be relevant
6. Write tests for your API
7. No need to make a view and datastore is optional
8. Error/bad request handling should be built out

### Design Philosophy

- Create as simple an API as possible while meeting all the given requirements
- Ensure the request experience is user friendly
- Follow RESTful API principles and HTTP Request/Response protocol
- Maximize test coverage

### Technologies

- Ruby on Rails
- SQLite3
- Nokogiri
- Rspec

### Stretch Goals

- Memoization for existing reviews to avoid scraping reviews if they have already been scraped in the past
- Expand Error handling to own service
- Add additional endpoints to get specific reviews, all reviews for a given business by business_id, etc.
