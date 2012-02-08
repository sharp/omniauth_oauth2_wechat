require 'rubygems'
require 'benchmark'
require 'eventmachine'
class Handler  < EventMachine::Connection
  def initialize(*args)
    super
  end
  
  def receive_data(data)
		puts "------------------------"
		@reply = data	
		@state = :processing
    EventMachine.defer(method(:do_something), method(:callback))
  rescue Exception => ex
    LOGGER.error "#{ex.class}: #{ex.message}\n#{ex.backtrace.join("\n")}"
  ensure
		puts data
    #close_connection_after_writing unless @state == :processing
  end
  
  def do_something
    #simulate a long running request
		a = []
		for i in 1..3000
			a << rand(3000)
			a.sort!
		end 
	  return @reply
  end
  
  def callback(msg)
		#puts msg
    self.send_data msg
    @state = :closing
  end
  
  def unbind
    close_connection_after_writing unless @state == :processing 
  end
  
end
 
EventMachine::run {
  EventMachine.epoll
  EventMachine::start_server("0.0.0.0", 8080, Handler)
  #EventMachine::open_datagram_socket("0.0.0.0", 10000, Handler)
  puts "Listening..."
}

