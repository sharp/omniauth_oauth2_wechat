require 'rubygems'
require 'benchmark'
require 'socket'
Benchmark.bm do |x|
  x.report("times:") do
    1.times.each do
      s = TCPSocket.new "127.0.0.1", 8080 
      s.send "test sending\n", 0
      puts "\n"  
      if line = s.recv(100)
        puts line
      end
      s.close
    end
  end
end
