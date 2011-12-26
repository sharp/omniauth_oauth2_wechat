require 'rubygems'
require 'benchmark'
require 'socket'
require 'logger'
Benchmark.bm do |x|
  logger = Logger.new('test.log', 10, 1024000) 
  logger.datetime_format = "%Y-%m-%d %H:%M:%S"
  x.report("times:") do
    for i in 1..10
      #Thread.new do
        TCPSocket.open "127.0.0.1", 8080 do |s|
          s.send "#{i}th sending\n", 0	
          if result = s.recv(100)  
            logger.info result
          end
          puts "#{i}th sending"
        #end
      end
    end
  end
end
