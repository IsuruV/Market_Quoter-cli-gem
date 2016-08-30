require_relative "../lib/company.rb"
require_relative "../lib/front_page.rb"
require_relative "../lib/google_scraper.rb"
require_relative "../lib/reddit_scraper.rb"
require_relative "../lib/market_quoter.rb"




ss = Market_Quoter.new
ss.run
# binding.pry

# puts "Hello! Welcome to Market Quoter!"
# puts "This gem will allow you to view financial data to help you make smarter investment decisions"
# puts "enter 'Today' to view current news and trends or 'Company' to search data pertaining to a specific pubiclicy traded company."
# input = gets.chomp
# if input == "Today"
#   front_page = Market_Quoter.new
#   front_page.run
#   puts "Select from the following choices:"
#   puts "-- News --"
#   puts "-- Indexes --"
#   puts "-- Current Gainers --"
#   puts "-- Current Losers -- "
#   input = gets.chomp
#   case input
#   when "News"
#     front_page.display_front_page_news
#   when "Indexes"
#     front_page.display_front_page_indexes
#   when "Current Gainers"
#     front_page.display_front_page_gainers
#   when "Current Losers"
#     front_page.display_front_page_losers
#   end
# end
