class ScrapeAndCreateBooksJob < ApplicationJob
  queue_as :default

  # Inside ScrapeAndCreateBooksJob
  def perform
    urls = UrlScraperService.scrape_urls

    urls.each do |url|
      # Scrape data from the URL
      series_name = extract_series_name(url)

      books = MangaScraper.scrape_data_from_url(url)

      # Create books and series based on the scraped data
      series = Series.create(name: series_name)
      books.each do |book_data|
        Book.create(
          name: book_data[:name],
          price: book_data[:price],
          availability: book_data[:availability],
          book_number: book_data[:book_number],
          buy_url: book_data[:buy_url],
          image_url: book_data[:image_url],
          series: series
        )
      end
    end
  end

  private

  def extract_series_name(url)
    # Extract the last element of the URL as the series name
    url_segments = url.split('/')
    series_name = url_segments.last
    # Remove dashes and capitalize each word
    series_name.gsub('-', ' ').titleize
  end
end
