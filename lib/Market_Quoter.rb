require_relative "../lib/company.rb"
require_relative "../lib/front_page.rb"
require_relative "../lib/google_scraper.rb"
require_relative "../lib/reddit_scraper.rb"
require_relative "../lib/market_quoter.rb"
require 'colorize'

class Market_Quoter
  attr_accessor :front_page, :new_company
  def run
    self.greetings
  end
  def make_front_page
    gainers_losers = Google_Scraper.scrape_front_page_gain_loss
    news = Google_Scraper.scrape_front_page_news
    indexes = Google_Scraper.scrape_front_page_indexes
    page = Front_Page.new(gainers_losers)
    page.set_from_hash(news)
    page.set_from_array(indexes)
    self.front_page = page
  end

  def make_company(input)
    reddit = Reddit_Scraper.scrape_squawk_box(input)
    summary = Google_Scraper.scrape_company_page_summary(input)
    managers = Google_Scraper.scrape_company_page_managers(input)
    stats = Google_Scraper.scrape_company_page_stats(input)
    events = Google_Scraper.scrape_company_page_events(input)
    ticker_price = Google_Scraper.scrape_company_current_price(input)

    company = Company.new(summary)
    company.set_events(events)
    company.set_posts(reddit)
    company.set_from_hash(managers)
    company.set_from_hash(stats)
    company.set_from_hash(ticker_price)
    self.new_company = company

  end

  def display_company_info
    puts ""
    puts ""
    puts "Company: #{new_company.name}".upcase.colorize(:blue).bold
    puts "----------------------------".bold
    puts ""
    puts "Description:".bold
    puts "#{new_company.description}"
    puts "website:".bold+ "#{new_company.website} "
    puts "----------------------------".bold
  end

  def display_company_managers
    managers = self.new_company.managers
    count = 0
    managers.each do |manager|
      if manager[:manager_name] != ""
      puts " "
      puts "#{count+=1}: ".bold+ "Title: #{manager[:manager_title]}".colorize(:blue).bold+ "---- Name: #{manager[:manager_name]}".bold
      puts " "
    end
    end
  end

  def display_company_stats
    s = []
    s = self.new_company.stats
    s.each do |ss|
      puts "#{ss[:stats_title]}".colorize(:blue).bold+ ": Recent Quarter:"+ " #{ss[:recent_quarter]}".bold+ " ---- Annual: "+ "#{ss[:yearly]} ".bold
      puts "---------------------------------------------------------------------------------------------------------------".bold

    end
  end

  def display_company_events
    events = new_company.events
    events.each do |event|
      puts ""
      puts ""
      puts "#{event}".colorize(:blue).bold
      puts "-------------------------".bold
    end
  end

  def display_company_posts
    posts = self.new_company.posts
    count = 0
    posts.each do |post|
      puts " "
      puts "#{count+=1}. #{post[:reddit_header]}".upcase.colorize(:light_blue).bold
      puts " "
      puts "#{post[:expanded]}"
      puts "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------".bold
      puts " "
    end
  end

  def display_company_price
    price = self.new_company.price
    puts " "
    print "$".bold+"#{price}".colorize(:green).bold + " /share".bold
    puts " "
  end

  def display_front_page_news
    newss = self.front_page.news
    newss.each do |news|
      puts "Title: #{news[:title]}".bold
      puts "Author: #{news[:author]}".colorize(:blue)
      puts "#{news[:snippet]}"
      puts "------------------------".bold
    end
  end

  def display_front_page_indexes
    indexes = self.front_page.indexes
    puts ""
    puts "Index ------ Value ------ Movement".bold
    indexes.each do |index|
      puts "#{index[:name]}   ".bold+  "#{index[:value]}   #{index[:movement]}"
      puts "------------------------------------"
    end
  end

  def display_front_page_gainers
    gainers = self.front_page.gainers
      puts "Ticker ------ Name ------ % Change ------ Market Cap".bold
    gainers.each do |gainer|
      puts "#{gainer[:symbol]} ,"+ "#{gainer[:company_name]}:".bold+ " #{gainer[:gain_loss]}".colorize(:green).bold+", #{gainer[:market_cap]}"
      puts "-------------------------------------------------------------------------------------"
    end

  end

  def display_front_page_losers
    # gainers_losers = Google_Scraper.scrape_front_page_gain_loss
    # gainers = Front_Page.new(gainers_losers).gainers
    # puts gainers.gainers
      puts "Ticker ------ Name ------ % Change ------ Market Cap".bold
    self.front_page.losers.each do |gainer|
      print "#{gainer[:symbol]}, "+"#{gainer[:company_name]}:".bold+ "#{gainer[:gain_loss]}".colorize(:red).bold+", #{gainer[:market_cap]}\n"
      puts "-------------------------------------------------------------------------------------"

    end
  end

  def greetings

    puts ""
    puts ""
    puts "Hello! Welcome to".bold+ " $$ Market Quoter! $$".colorize(:green).bold
    puts ""
    puts "This gem will allow you to view financial data to help you make smarter investment decisions.".bold
    puts "enter ".bold+ "'Today'".colorize(:blue).bold+ " to view current news and trends or".bold+ " 'Company'".colorize(:red).bold+ " to search data pertaining to a specific publicly traded company.".bold
    puts ""
    print "Choice: "
    input = gets.chomp
    if input.upcase == "TODAY"
      self.front
    elsif input.upcase == "COMPANY"
      self.new_comp
      self.comp
    end
  end

  def front
    front_page = Market_Quoter.new
    front_page.make_front_page
    puts ""
    puts ""
    puts "** Enter ".underline+"'Menu'".underline+ " to go back to the main menu or ".underline+ "'Company'".underline+ " to start a company search **".underline
    puts ""
    puts "Select from the following choices:"
    puts ""
    puts "-- News --".bold+ "      (Displays current financial headline news)"
    puts ""
    puts "-- Indexes --".bold+ "   (Displays the statues of most popular indexes)"
    puts ""
    puts "-- Gainers --".bold+ "   (Displays the stocks with the most daily gains)"
    puts ""
    puts "-- Losers -- ".bold+ "   (Displays stocks with the most daily losses)"
    puts ""
    puts ""
    print "Choice: "
    input = gets.chomp
    case input.upcase
    when "NEWS"
      front_page.display_front_page_news
      self.front
    when "INDEXES"
      front_page.display_front_page_indexes
      self.front
    when "GAINERS"
      front_page.display_front_page_gainers
      self.front
    when "LOSERS"
      front_page.display_front_page_losers
      self.front
    when "COMPANY"
      self.new_comp
      self.comp
    when "MENU"
      self.greetings
    end
  end

  def new_comp
    puts ""
    puts "Enter a company name or ticker symbol".bold
    puts ""
    input = gets.chomp
      if input.upcase == "MENU"
        self.greetings
      else
      company = Market_Quoter.new
      company.make_company(input)
      @current = company
      end
  end
  def comp
    # puts "Enter a company name or ticker"
    # input = gets.chomp
    # company = Market_Quoter.new
    # company.make_company(input)
    puts ""
    puts ""
    puts "** Enter 'Menu' to go back to the main menu or 'Today' to view current news and trends **".underline
    puts ""
    puts "Select from the following choices:"
    puts ""
    puts "-- About --".bold+ "     (Short description about the company)"
    puts "-- Managers --".bold+ "  (Lists the ranking leaders of the company)"
    puts "-- Price -- ".bold+ "    (Current price the company is trading at)"
    puts "-- Earnings --".bold+ "  (Earnings report)"
    puts "-- Events -- ".bold+ "   (Current and upcoming events effecting the company)"
    puts "-- Opinions --".bold+ "  (Opinons of other private investors about the company)"
    puts ""
    puts ""
    print "Choice: "
    input = gets.chomp
    case input.upcase
    when "ABOUT"
      @current.display_company_info
      self.comp
    when "MANAGERS"
        @current.display_company_managers
        self.comp
      when "PRICE"
        @current.display_company_price
        self.comp
      when "EARNINGS"
        @current.display_company_stats
        self.comp
      when "EVENTS"
        @current.display_company_events
        self.comp
      when "OPINIONS"
        @current.display_company_posts
        self.comp
      when "TODAY"
        self.front
      when "Menu"
        self.greetings
      when "COMPANY"
        self.new_comp
        self.comp
    end
  end

end







#*********************************************************************************
# require "Market_Quoter/version"
#
# module MarketQuoter
#   # Your code goes here...
# end
# require_relative "../lib/company.rb"
# require_relative "../lib/front_page.rb"
# require_relative "../lib/google_scraper.rb"
# require_relative "../lib/reddit_scraper.rb"
#
# class Market_Quoter
#
#   def make_front_page
#     gainers_losers = Google_Scraper.scrape_front_page_gain_loss
#     news = Google_Scraper.scrape_front_page_news
#     indexes = Google_Scraper.scrape_front_page_indexes
#     front_page = Front_Page.new(gainers_losers)
#     front_page.set_from_hash(news)
#     front_page.set_from_array(indexes)
#   end
#
#   def make_company(input)
#     reddit = Reddit_Scraper.scrape_squawk_box(input)
#     summary = Google_Scraper.scrape_company_page_summary(input)
#     managers = Google_Scraper.scrape_company_page_managers(input)
#     stats = Google_Scraper.scrape_company_page_stats(input)
#     events = Google_Scraper.scrape_company_page_events(input)
#     ticker_price = Google_Scraper.scrape_company_current_price(input)
#
#     new_company = Company.new(summary)
#     new_company.set_events(events)
#     new_company.set_posts(reddit)
#     new_company.set_from_hash(managers)
#     new_company.set_from_hash(stats)
#     new_company.set_from_hash(ticker_price)
#
#   end
#
#   # def add_attributes_to_students
#   #   Student.all.each do |student|
#   #     attributes = Scraper.scrape_profile_page(student.profile_url)
#   #     student.add_student_attributes(attributes)
#   #   end
#   # end
#
#   # def display_students
#   #   Student.all.each do |student|
#   #     puts "#{student.name.upcase}".colorize(:blue)
#   #     puts "  location:".colorize(:light_blue) + " #{student.location}"
#   #     puts "  profile quote:".colorize(:light_blue) + " #{student.profile_quote}"
#   #     puts "  bio:".colorize(:light_blue) + " #{student.bio}"
#   #     puts "  twitter:".colorize(:light_blue) + " #{student.twitter}"
#   #     puts "  linkedin:".colorize(:light_blue) + " #{student.linkedin}"
#   #     puts "  github:".colorize(:light_blue) + " #{student.github}"
#   #     puts "  blog:".colorize(:light_blue) + " #{student.blog}"
#   #     puts "----------------------".colorize(:green)
#   #   end
#   # end
#
#   def display_company_info
#     puts "Company: #{new_company.name}"
#     puts "----------------------------"
#     puts "Description:"
#     puts "#{new_company.description}"
#     puts "website: #{new_company.website} "
#   end
#
#   def display_company_managers
#     managers = new_company.managers
#     count = 0
#     managers.each do |manager|
#       puts "#{count+=1}: Title: #{manager[:manager_title]} ---- Name: #{manager[:manager_name]}"
#     end
#   end
#
#   def display_company_stats
#     stats = new_company.stats
#     stats.each do |stat|
#       puts "#{stats[:stats_title]}: Recent Quarter Return: #{stats[:recent_quarter]} ---- Annual Return: #{stats[:yearly]} "
#       puts "---------------------------------------------------------------------------------------------------------------"
#     end
#   end
#
#   def display_company_events
#     events = new_company.events
#     events.each do |event|
#       puts "#{event}"
#       puts "--------"
#     end
#   end
#
#   def display_company_posts
#     posts = new_company.posts
#     posts.each do |post|
#       puts "#{post[:reddit_header]}"
#       puts "#{post[:expanded]}"
#       puts "-----------------------"
#     end
#   end
#
#   def display_front_page_news
#     newss = front_page.news
#     newss.each do |news|
#       puts "Title: #{news[:title]}"
#       puts "Author: #{news[:author]}"
#       puts "#{news[:snippet]}"
#       puts "------------------------"
#     end
#   end
#
#   def display_front_page_indexes
#     indexes = front_page.indexes
#     puts "Index ---- Value ---- Movement"
#     indexes.each do |index|
#       puts "#{index[:name]}  #{index[:value]}   #{index[:movement]}"
#       puts " "
#     end
#   end
#
#   def display_front_page_gainers
#     gainers = front_page.gainers
#       puts "Ticker ---- Name ---- % Change ---- Market Cap"
#     gainers.each do |gainer|
#       puts "#{gainer[:symbol]}, #{gainer[:company_name]}: #{gainer[:gain_loss]}, #{gainer[:market_cap]}"
#     end
#
#   end
#
#   def display_front_page_losers
#     losers = front_page.losers
#       puts "Ticker ---- Name ---- % Change ---- Market Cap"
#     gainers.each do |gainer|
#       puts "#{gainer[:symbol]}, #{gainer[:company_name]}: #{gainer[:gain_loss]}, #{gainer[:market_cap]}"
#     end
#
#   end
# end
