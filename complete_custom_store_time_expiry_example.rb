require 'faraday'
require 'faraday_middleware'
require 'json'
require './my_cache_store_with_time_expiry'


store  = MyCacheStoreWithTimeExpiry.new

CONNECTION = Faraday.new(url: 'https://api.github.com/') do |faraday|
  faraday.use FaradayMiddleware::Caching, store
  faraday.request  :url_encoded
  faraday.adapter  Faraday.default_adapter
  faraday.response :logger
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
