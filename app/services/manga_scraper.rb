class MangaScraper

  require 'json'
  require 'nokogiri'
  require 'net/http'
  require 'uri'

  def has_stock(has_stock_url)
    return true if has_stock_url == "http://schema.org/InStock"
    return false if has_stock_url == "http://schema.org/OutOfStock"
  end

  def self.scrape_data_from_url(manga_url)

    base_url = 'https://www.lacomiqueria.com.ar'
    page_number = 1

    books= []

    loop do
      url = "#{base_url}#{manga_url}page/#{page_number}/"
      uri = URI.parse(url)

      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      html_content = response.body
      doc = Nokogiri::HTML(html_content)
      data_components = doc.css('script[data-component="structured-data.item"]').map(&:text)

      # If there are no products on the page, stop the loop
      break if data_components.empty?

      data_components.each do |json_ld_script|
        json_data = JSON.parse(json_ld_script)
        name = json_data.dig("name")
        next if name.include?("SERIE COMPLETA")

        book_info = {
          name: name,
          price: json_data.dig("offers", "price"),
          availability: json_data.dig("offers", "availability"),
          book_number: json_data.dig("name").scan(/\d+/).last.to_i,
          buy_url: json_data.dig("offers", "url"),
          image_url: json_data["image"]
        }

        books << book_info

      end

      page_number += 1
    end
    books
  end
end
