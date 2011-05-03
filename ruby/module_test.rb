module Test
	@connection = nil
	def self.included(base)
		puts self.class
		@connection = base
	end

	def print
		puts self
		puts @connection
	end
end

class ModuleTest
	include Test
end

m = ModuleTest.new
m.print
