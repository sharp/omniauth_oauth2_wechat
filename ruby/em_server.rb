require 'rubygems'
require 'eventmachine'
class Handler  < EventMachine::Connection
  def receive_data(data)
		#operation = proc do
      puts data		
    #end
 
    # Callback block to execute once the request is fulfilled
    #callback = proc do |res|
    	send_data "send_response"
    #end
		#EM.defer(operation, callback)
    #close_connection#_after_writing
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

