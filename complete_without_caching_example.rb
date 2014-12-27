require 'faraday'
require 'faraday_middleware'
require 'json'


CONNECTION = Faraday.new(url: 'https://api.github.com/') do |faraday|
  faraday.request  :url_encoded
  faraday.adapter  Faraday.default_adapter
  faraday.response :logger
end

load File.expand_path('../', __FILE__) + '/fetcher.rb'

__END__

❯ ruby complete_without_caching_example.rb
Number of stargazers:    30
Number of requests made: 10
Response times: [1.3, 1.03, 1.02, 1.01, 1.15, 0.99, 1.18, 1.1, 1.11, 1.03]
