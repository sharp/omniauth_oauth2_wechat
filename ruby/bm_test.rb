require 'rubygems'
require 'benchmark'
Benchmark.bm do |x|
	x.report("times:") do
    10.times.each do
		a = []
		n = 10000
		for i in 1..n
			a << rand(n)
			a.sort!
		end
	end
  end
end

