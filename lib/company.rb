require 'pry'
require 'open-uri'
require 'nokogiri'

# #********************************************************
# class Google_Scraper
# @@all = []
#   ## gainers_losers *gets the top daily gainers and losers*
#   # def initialize(input)
#   #   Google_Scraper.scrape_company_page_managers(input)
#   #   @@all << self
#   # end
#   def self.scrape_front_page_gain_loss
#     front_page = Nokogiri::HTML(open("https://www.google.com/finance"))
#     gainers_losers = []
#     gainers = []
#     losers = []
#     companies = {}
#
#     front_page.css("div#topmovers").css(".g-wrap").css("tr").each do |company|
#       company_name = company.css(".name").text
#       company_symbol = company.css(".symbol").text
#       company_change = company.css(".change").text
#       market_cap = company.css(".mktCap").text
#       gainers_losers << {company_name: company_name, symbol: company_symbol, gain_loss: company_change, market_cap: market_cap }
#     end
#     gainers_losers.each do |company|
#       if company[:gain_loss].to_i <= 0 && company[:gain_loss] != "" && company[:company_name] != "" && company[:symbol] != "" && company[:market_cap] != ""
#         losers << company
#       elsif company[:gain_loss].to_i >= 0 && company[:gain_loss] != "" && company[:company_name] != "" && company[:symbol] != "" && company[:market_cap] != ""
#         gainers << company
#       end
#     end
#
#     companies[:gainers] = gainers
#     companies[:losers] = losers
#     companies
#   end
#   ## gainers_losers end
#
#   ## news *gets the daily top market news*
#   def self.scrape_front_page_news
#     news = []
#     news_hash = {}
#     front_page = Nokogiri::HTML(open("https://www.google.com/finance"))
#
#     front_page.css("div#mk-news").css(".cluster").each do |article|
#       title = article.css(".title").text
#       author = article.css(".byline").text
#       snippet = article.css(".snippet").text
#       news << {title: title, author: author, snippet: snippet}
#     end
#       news
#       news_hash[:news] = news
#       news_hash
#   end
#   ##news end
#
#   def self.scrape_front_page_indexes
#     indexes = []
#     front_page = Nokogiri::HTML(open("https://www.google.com/finance"))
#
#     front_page.css("table#sfe-mktsumm").css("tr").each do |index|
#       name = index.css("td").css(".name").text
#       value = index.css("td").css("span").text
#       # value = value.split(/\b-\b/)
#       value = value.split("+") || value.split("-")
#       indexes << {name: name, value: value[0], movement: value[1]}
#     end
#     indexes
#   end
#
#   def self.scrape_company_page_summary(input)
#     company_page = Nokogiri::HTML(open("https://www.google.com/finance?q="+"#{input}"))
#     summary = {}
#
#     description = company_page.css(".companySummary").text
#     # address = company_page.css(".g-c").css("div").css(".sfe-section").text
#     website = company_page.css(".g-c").css(".sfe-section").css(".item").css("a").first.text
#     summary[:description] = description
#     # summary[:address] = address
#     summary[:website] = website
#     summary[:name] = input
#     summary
#   end
#   #summary end
#
#   ## managers * returns the managers of the company
#   def self.scrape_company_page_managers(input)
#     company_page = Nokogiri::HTML(open("https://www.google.com/finance?q="+"#{input}"))
#     managers = []
#     managers_hash = {}
#     company_page.css(".id-mgmt-table").css("tr").each do |manager|
#       name = manager.css(".p").text
#       title = manager.css(".t").text
#       managers << {manager_name: name, manager_title: title}
#     end
#     managers_hash[:managers] = managers
#     managers_hash
#   end
#   ## managers end
#   def self.scrape_company_page_stats(input)
#     company_page = Nokogiri::HTML(open("https://www.google.com/finance?q="+"#{input}"))
#
#     stats = []
#     stats_hash = {}
#     company_page.css(".quotes").css("tr").each do |stat|
#       title = stat.css(".name").text
#       ret = stat.css(".period").text.split("\n")
#       stats << {stats_title: title, recent_quarter: ret[0], yearly: ret[1]}
#       end
#     # stats << {last_price: company_page.css(".id-price-panel").css(".pr").text}
#     stats_hash[:stats] = stats
#     stats_hash
#   end
#
#   def self.scrape_company_page_events(input)
#     company_page = Nokogiri::HTML(open("https://www.google.com/finance?q="+"#{input}"))
#     events = []
#     company_page.css(".events").css(".event").each do |event|
#       events << event.text
#     end
#     events
#   end
# end
#
#
#
#
#
#
# #********************************************************
class Company

  attr_accessor :website, :managers, :description, :ticker
  attr_accessor :name, :events, :stats, :posts, :price
  @@all = []

  def initialize(summary_hash)
    if summary_hash
    summary_hash.each do |key,value|
     self.send("#{key}=", value)
     @@all << self
    end
  end
end

  def set_from_array(array)
    array.each do |hash|
    hash.each do |key,value|
     self.send("#{key}=", value)
      end
    end
end

  def set_from_hash(hash)
    if hash
    hash.each do |key,value|
     self.send("#{key}=", value)
      end
    end
  end

  def set_events(events_array)
    self.events = events_array
  end

  def set_posts(posts_array)
    self.posts = posts_array
  end

  def self.all
    @@all
  end

end
