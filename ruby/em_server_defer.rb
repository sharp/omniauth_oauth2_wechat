require 'rubygems'
require 'benchmark'
require 'eventmachine'
class Handler  < EventMachine::Connection
  def initialize(*args)
    super
  end
  
  def receive_data(data)
		@state = :processing
    EventMachine.defer(method(:do_something), method(:callback))
		#EM.defer(operation, callback)
  rescue Exception => ex
    LOGGER.error "#{ex.class}: #{ex.message}\n#{ex.backtrace.join("\n")}"
  ensure
    close_connection_after_writing unless @state == :processing
  end
  
  def do_something
    #simulate a long running request
		for i in 1..1000
			a << rand(1000)
			a.sort!
		end 
	  return "response from server"
  end
  
  def callback(msg)
    self.send_data msg
    @state = :closing
  end
  
  def unbind
    close_connection_after_writing unless @status == :process 
  end
  
end
 
EventMachine::run {
  EventMachine.epoll
  EventMachine::start_server("0.0.0.0", 8080, Handler)
  puts "Listening..."
}

