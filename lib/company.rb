require 'pry'
require 'open-uri'
require 'nokogiri'

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
