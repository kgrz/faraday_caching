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
    raise('Block should be provided') unless block_given?
    result = read(key)

    if result.nil?
      result = yield
      write(key, result)
      result
    else
      result
    end
  end
end
