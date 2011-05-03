require 'rubygems'
require 'benchmark'
require 'socket'
Benchmark.bm do |x|
	x.report("times:") do
		for i in 1..20
			TCPSocket.open "127.0.0.1", 8080 do |s|
    		s.send "#{i}th sending\n", 0	
				if line = s.gets
					puts line
				end
				puts "#{i}th sending"
			end
		end
	end
end
