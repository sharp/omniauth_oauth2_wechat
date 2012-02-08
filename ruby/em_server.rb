require 'rubygems'
require 'eventmachine'
class Handler  < EventMachine::Connection
  def initialize(*args)
    super
  end
  
  def receive_data(data)
		puts data
		operation = proc do
			# simulate a long running request
 			a = []
			for i in 1..10
				a << rand(10)
				a.sort!
			end
		end
 
    # Callback block to execute once the request is fulfilled
    callback = proc do |res|
    	send_data data
    end
		EM.defer(operation, callback)
  end
	
	def unbind
    close_connection_after_writing
  end
end
 
EventMachine::run {
  EventMachine.epoll
  EventMachine::start_server("0.0.0.0", 8080, Handler)
  puts "Listening..."
}

