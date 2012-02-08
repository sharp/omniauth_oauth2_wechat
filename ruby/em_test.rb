require 'rubygems'
require 'benchmark'
require 'socket'
require 'logger'
Benchmark.bm do |x|
  logger = Logger.new('test.log', 10, 1024000) 
  logger.datetime_format = "%Y-%m-%d %H:%M:%S"
	logger.info "----------------------------------"
  x.report("times:") do
    for i in 0..100
      Thread.new do
        TCPSocket.open "127.0.0.1", 8080 do |s|
					s.send "#{i}", 0
          if result = s.recv(100)  
            logger.info result
          end
        end
      end
			#sleep 0.1
    end
		while true
			sleep 10
			puts "alive"
		end
  end
end
