require 'faraday'
require 'faraday_middleware'
require 'json'
require './my_cache_store'


store  = MyCacheStore.new

CONNECTION = Faraday.new(url: 'https://api.github.com/') do |faraday|
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
