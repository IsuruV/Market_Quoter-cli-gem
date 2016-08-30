class Front_Page
    @@all = []
    attr_accessor :indexes, :news, :gainers, :losers
    def initialize(hash)
      if hash
      hash.each do |key,value|
       self.send("#{key}=", value)
       @@all << self
      end
    end
  end

  def set_from_array(array)
    self.indexes = array
  end

  def set_from_hash(hash)
    if hash
    hash.each do |key,value|
     self.send("#{key}=", value)
      end
    end
  end
end
