require 'watir'
require 'nokogiri'

class UrlScraperService
  def self.scrape_urls
    browser = Watir::Browser.new(:chrome, headless: true) # Use Chrome in headless mode
    browser.goto('https://www.lacomiqueria.com.ar')

    # Wait for the page to load completely (adjust sleep duration as needed)
    sleep 2

    # Get the HTML content after JavaScript execution
    html_content = browser.html
    browser.close

    # Parse the HTML content with Nokogiri
    doc = Nokogiri::HTML(html_content)

    # Extract URLs
    urls = doc.css('a').map { |link| link['href'] }

    # Filter and format URLs
    unique_urls = Set.new
    urls.each do |url|
      if url && url.start_with?('https://www.lacomiqueria.com.ar') && url.include?('://')
        cleaned_url = url.gsub('https://www.lacomiqueria.com.ar', '')
        unique_urls.add(cleaned_url)
      end
    end

    # Format URLs as CSV content
    csv_content = unique_urls.map { |url| "\"#{url}\"" }.join("\n")
    unique_urls.select! { |url| url.include?("manga") }

    unique_urls
  end

end
