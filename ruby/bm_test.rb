require 'rubygems'
require 'benchmark'
Benchmark.bm do |x|
	x.report("times:") do
		a = []
		n = 10000
		for i in 1..n
			a << rand(n)
			a.sort!
		end
	end
end
