class MyCacheStore
  attr_accessor :store_hash
  attr_reader :options

  def initialize(options = {})
    @store_hash = {}
    @options = options
    @refresh_in = options.fetch(:refresh_in) { Float::INFINITY }
  end

  def write(key, value)
    @store_hash[key.to_sym] = { value: value, created_at: Time.now }
  end

  def read(key)
    value_hash = @store_hash[key.to_sym]
    return nil unless value_hash
    if Time.now - value_hash[:created_at] > @refresh_in
      nil
    else
      value_hash[:value]
    end
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

