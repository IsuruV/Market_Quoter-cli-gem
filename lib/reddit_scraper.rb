require 'pry'
require 'nokogiri'
require 'httpclient'

class Reddit_Scraper
  ## squawk_box * displays what others are saying about company on reddit/investing
  def self.scrape_squawk_box(input)
    # front_page = Nokogiri::HTML(open("https://www.google.com/finance?q=apple&ei=X1bAV9mnBYjBesP3tsgM"))
       http = HTTPClient.new
       front_page = Nokogiri::HTML(http.get_content("https://www.reddit.com/r/investing/search?q=#{input}"+"&restrict_sr=on"))

        posts = []
        front_page.css(".search-result").each do |post|
        header = post.css(".search-result-header").css("a").text
        expanded = post.css(".search-expando").css(".md").css("p").text
        posts << {reddit_header: header, expanded: expanded}
    end
      posts
  end
end
