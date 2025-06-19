#  raise IndexError if index.negative? || index >= @buckets.length

class HashMap

  def initialize
    @load_factor = 0.75
    @capacity = 0
    @buckets = Array.new(16){[]}
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
        
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
        
    hash_code
  end

  def set(key, value)
    #If current amount of buckets is over the max * load_factor then double the amount of buckets
    if @capacity >= (@buckets.length * @load_factor)
      new_len = @buckets.length * 2
      expansion = Array.new(new_len){[]}
      
      #Rehash
      loop_buckets do |entry| 
          code = hash(entry[0])%new_len
          
          expansion[code] << entry
      end
      
      @buckets = expansion
    end
    
    code = hash(key) % @buckets.length
    
    #Checks if there is already the same key, if so then change only the value
    if @buckets[code]
      @buckets[code].each do |entry|
        next unless entry[0] == key
        entry[1] = value 
        return
      end
    end

    @capacity += 1
    @buckets[code] << [key, value]
  end

  def get(key)
    code = hash(key) % @buckets.length

    @buckets[code].each do |entry|
      return entry[1] if entry[0] == key
    end

    nil
  end

  def has?(key)
    loop_buckets{|entry| return true if entry[0] == key}
    false
  end

  def remove(key)
    code = hash(key) % @buckets.length
    location = nil

    @buckets[code].each_with_index {|entry,index| location = index if entry[0] == key}
    return location if location.nil?

    @buckets[code].delete_at(location)
    @capacity -= 1
  end

  def length
    return @capacity
  end

  def clear
    @buckets = Array.new(16){[]}
  end

  def keys
    key_list = []
    loop_buckets {|entry| key_list << entry[0]}
    key_list
  end

  def values
    value_list = []
    loop_buckets {|entry| value_list << entry[1]}
    value_list
  end

  def entries
    entries = []
    loop_buckets {|entry| entries << entry}
    entries
  end

  def loop_buckets
    @buckets.each do |bucket|
      next if bucket.nil?
      bucket.each do |entry|
        yield(entry)
      end
    end
  end
end