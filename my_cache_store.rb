class MyCacheStore
  attr_accessor :store_hash

  def initialize
    @store_hash = {}
  end

  def write(key, value)
    @store_hash[key.to_sym] = value
  end

  def read(key)
    @store_hash[key.to_sym]
  end

  def fetch(key)
    result = read(key)

    if result.nil?
      if block_given?
        result = yield
        write(key, result)
        result
      else
        result
      end
    else
      result
    end
  end
end
