require 'rubygems'
require 'socket'

server = TCPServer.open(8080)
loop {
  client = server.accept
  sleep(2)
  client.puts("hi, i am server")
  client.close
}
