require 'pry'
require 'open-uri'
require 'nokogiri'

class Google_Scraper
@@all = []

  def self.scrape_front_page_gain_loss

      front_page = Nokogiri::HTML(open("https://www.google.com/finance"))
      gainers_losers = []
      gainers = []
      losers = []
      companies = {}

      front_page.css("div#topmovers").css(".g-wrap").css("tr").each do |company|
        company_name = company.css(".name").text.strip
        company_symbol = company.css(".symbol").text.strip
        company_change = company.css(".change").text.strip
        market_cap = company.css(".mktCap").text.strip
        gainers_losers << {company_name: company_name, symbol: company_symbol, gain_loss: company_change, market_cap: market_cap }
      end
      gainers_losers.each do |company|
        if company[:gain_loss].to_i <= 0.00 && company[:gain_loss] != "" && company[:company_name] != "" && company[:symbol] != "" && company[:market_cap] != ""
          losers << company
        elsif company[:gain_loss].to_i >= 0.00 && company[:gain_loss] != "" && company[:company_name] != "" && company[:symbol] != "" && company[:market_cap] != ""
          gainers << company
        end
      end

      companies[:gainers] = gainers
      companies[:losers] = losers
      companies
    end
    ## gainers_losers end

    ## news *gets the daily top market news*
    def self.scrape_front_page_news
      news = []
      news_hash = {}
      front_page = Nokogiri::HTML(open("https://www.google.com/finance"))

      front_page.css("div#mk-news").css(".cluster").each do |article|
        title = article.css(".title").text
        author = article.css(".byline").text
        snippet = article.css(".snippet").text
        news << {title: title, author: author, snippet: snippet}
      end
        news
        news_hash[:news] = news
        news_hash
    end
    ##news end

    def self.scrape_front_page_indexes
      indexes = []
      front_page = Nokogiri::HTML(open("https://www.google.com/finance"))

      front_page.css("table#sfe-mktsumm").css("tr").each do |index|
        name = index.css("td").css(".name").text
        value = index.css("td").css("span").text
        # value = value.split(/\b-\b/)
        value = value.split("+") || value.split("-")
        indexes << {name: name, value: value[0], movement: value[1]}


      end
      indexes
    end

    def self.scrape_company_page_summary(input)
      company_page = Nokogiri::HTML(open("https://www.google.com/finance?q="+"#{input}"))
      summary = {}

      description = company_page.css(".companySummary").text
      website = company_page.css(".g-c").css(".sfe-section").css(".item").css("a").first.text
      summary[:description] = description
      summary[:website] = website
      summary[:name] = input
      summary
    end
    #summary end

    ## managers * returns the managers of the company
    def self.scrape_company_page_managers(input)
      company_page = Nokogiri::HTML(open("https://www.google.com/finance?q="+"#{input}"))
      managers = []
      managers_hash = {}
      company_page.css(".id-mgmt-table").css("tr").each do |manager|
        name = manager.css(".p").text
        title = manager.css(".t").text
        managers << {manager_name: name, manager_title: title}
      end
      managers_hash[:managers] = managers
      managers_hash
    end
    ## managers end
    def self.scrape_company_page_stats(input)
      company_page = Nokogiri::HTML(open("https://www.google.com/finance?q="+"#{input}"))

      stats = []
      stats_hash = {}
      company_page.css(".quotes").css("tr").each do |stat|
        title = stat.css(".name").text
        ret = stat.css(".period").text.split("\n")
        stats << {stats_title: title, recent_quarter: ret[0], yearly: ret[1]}
        end
      stats_hash[:stats] = stats
      stats_hash
      # stats
    end

    def self.scrape_company_page_events(input)
      company_page = Nokogiri::HTML(open("https://www.google.com/finance?q="+"#{input}"))
      events = []
      company_page.css(".events").css(".event").each do |event|
        events << event.text.strip
      end
      events
    end

    def self.scrape_company_current_price(input)
      company_page = Nokogiri::HTML(open("https://www.google.com/finance?q="+"#{input}"))
      current_price = {}
      price = company_page.css(".pr").text.strip
      ticker = company_page.css(".appbar-snippet-secondary").css("span").text.strip
      current_price[:ticker] = ticker
      current_price[:price] = price
      current_price
    end

end

# end
