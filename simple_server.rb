require 'socket'


module SimpleServer

class Server

  def initialize
    @server = TCPServer.open(2000) #open method is the exact same as File.open. inherits from IO
  end

  def run
    loop do
      client = @server.accept #instance method of TCPServer. waits for connection, returns TCPSocket representing that connection
      
      
      while line = client.gets #gets requests from client
        puts line.chomp
        break if line =~ /^\s*$/
        request = Request.new(line) # parses the line into a Request
      end

      client.puts(Time.now.ctime) #now when puts to that socket, client picks up on other side.
      client.puts "Closing the connection. Bye!"
      client.close
    end
  end
  
end

#parses a string into the three parts of an HTML request
class Request
  attr_reader :method, :address, :version
  def initialize(string)
    if string ~= /^GET/
      parts = string.split(" ") #an HTML GET is split by spaces
      @method = parts[0] #first part is GET
      @address = parts[1] #second part is the address
      @version = parts[2] #third part is the HTML version
    elsif string ~= /^POST/
      @method = "POST"
      #deal with rest of lines
    end
  end
  
  def post?
    @method == "POST"
  end
  
  def get?
    @method == "GET"
  end
end

end
