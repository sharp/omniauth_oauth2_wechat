require 'rubygems'
require 'socket'

socket = TCPServer.open(8080)
loop do
  sock = socket.accept
  data = sock.recv(100)
  puts data.unpack('B*').to_s
  sock.write("hi, i am server")
  sock.close
end
