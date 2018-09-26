require 'concurrent'
require 'rest-client'

    url = 'https://jsonplaceholder.typicode.com/photos'
    fs = []
    # executor = Concurrent::CachedThreadPool.new
    # executor = Concurrent::ThreadPoolExecutor.new
    executor = Concurrent::FixedThreadPool.new(5)
    start_time = Time.now
    1000.times do 
        fs.push(Concurrent::Promise.execute opts = {:executor => executor} {
            RestClient.get url
        })
    end

    fs.each(&:wait)
    Concurrent::Promise.all?(fs).execute.wait
    puts "#{1000 * (Time.now - start_time)}ms"
    fs.each do |f|
         print f.value.code, ' '
    end
    # puts "#{1000 * (Time.now - start_time)}ms"

=begin
prom = Concurrent::Promise.all?(
 Concurrent::Promise.execute { puts '1'; sleep 3},
 Concurrent::Promise.execute { puts '2' }
).then{ puts "Succeeded"; 'ok'}.
  rescue{ |reason| puts "Failed with #{reason}" }.execute.wait


puts prom.value
=end