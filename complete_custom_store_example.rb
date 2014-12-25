require 'faraday'
require 'faraday_middleware'
require 'tempfile'
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

# GitHub's API returns a JSON response

FETCHER = lambda do |counts, times|
  start_time = Time.now
  response = connection.get('/repos/sinatra/sinatra/stargazers')
  end_time = Time.now

  response_hash = JSON.load(response.body)
  counts << response_hash.count
  times << (end_time - start_time).round(2)
end

counts = []
times  = []

10.times do
  FETCHER.call(counts, times)
end

puts "Number of stargazers:    #{counts.uniq.first}"
puts "Number of requests made: #{counts.count}"
puts "Response times: #{times}"


__END__


❯ ruby complete_custom_store_example.rb
Number of stargazers:    30
Number of requests made: 10
Response times: [1.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
