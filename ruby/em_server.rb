require 'rubygems'
require 'eventmachine'
class Handler  < EventMachine::Connection
  def initialize(*args)
    super
  end
  
  def receive_data(data)
		operation = proc do
			# simulate a long running request
 			a = []
			for i in 1..1000
				a << rand(1000)
				a.sort!
			end
		end
 
    # Callback block to execute once the request is fulfilled
    callback = proc do |res|
    	send_data "data from server"
    end
	end
  
	def unbind
    #EventMachine::stop_event_loop
    #close_connection_after_writing
  end
end
 
EventMachine::run {
  #EventMachine.epoll
  EventMachine::start_server("0.0.0.0", 8080, Handler)
  puts "Listening..."
}

