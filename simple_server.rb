require 'socket'

server = TCPServer.open(2000) #open method is the exact same as File.open. inherits from IO
loop {
  client = server.accept #instance method of TCPServer. waits for connection, returns TCPSocket representing that connection
  client.puts(Time.now.ctime) #now when puts to that socket, client picks up on other side.
  client.puts "Closing the connection. Bye!"
  client.close
}
