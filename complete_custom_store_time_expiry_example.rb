require 'faraday'
require 'faraday_middleware'
require 'json'

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


store  = MyCacheStore.new(refresh_in: 0.0001)

CONNECTION = Faraday.new(url: 'https://api.github.com/') do |faraday|
  faraday.use FaradayMiddleware::Caching, store
  faraday.request  :url_encoded
  faraday.adapter  Faraday.default_adapter
end

load File.expand_path('../', __FILE__) + '/fetcher.rb'

__END__

With no :refresh_in option set

❯ ruby complete_custom_store_time_expiry_example.rb
Number of stargazers:    30
Number of requests made: 10
Response times: [1.51, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]


With a :refresh_in option of 0.0001 set

❯ ruby complete_custom_store_time_expiry_example.rb
Number of stargazers:    30
Number of requests made: 10
Response times: [1.2, 1.1, 1.01, 2.48, 0.98, 0.99, 1.08, 1.23, 1.43, 1.13]
