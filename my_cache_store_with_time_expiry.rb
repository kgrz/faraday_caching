require './my_cache_store'

class MyCacheStoreWithTimeExpiry < MyCacheStore
  attr_reader :options

  def initialize(options = {})
    super()
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
end

