require 'rubygems'
require 'benchmark'
require 'eventmachine'
class Handler  < EventMachine::Connection
  def receive_data(data)
		operation = proc do
			# simulate a long running request
 			a = []
			n = 5000
			for i in 1..n
				a << rand(n)
				a.sort!
			end
		end
 
    # Callback block to execute once the request is fulfilled
    callback = proc do |res|
    	send_data "send_response\n"
    end

		puts data
		EM.defer(operation, callback)
  end
end
 
EventMachine::run {
  EventMachine.epoll
  EventMachine::start_server("0.0.0.0", 8080, Handler)
  puts "Listening..."
}

