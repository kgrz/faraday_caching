require 'faraday'
require 'faraday_middleware'
require 'json'

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


store  = MyCacheStore.new

connection = Faraday.new(url: 'https://api.github.com/') do |faraday|
  faraday.use FaradayMiddleware::Caching, store
  faraday.request  :url_encoded
  faraday.adapter  Faraday.default_adapter
end

load File.expand_path('../', __FILE__) + '/fetcher.rb'

__END__


❯ ruby complete_custom_store_example.rb
Number of stargazers:    30
Number of requests made: 10
Response times: [1.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
