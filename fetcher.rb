FETCHER = lambda do |counts, times|
  start_time = Time.now
  response = CONNECTION.get('/repos/sinatra/sinatra/stargazers')
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

