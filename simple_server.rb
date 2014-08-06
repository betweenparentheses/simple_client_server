require 'socket'


module SimpleServer

class Server

  def initialize
    @server = TCPServer.open(2000) #open method is the exact same as File.open. inherits from IO
  end

  def status_line(code)
    version = "HTTP/1.0"
    case code
    when 200 then message = "OK"
    when 404 then message = "Not Found"
    else return nil 
    end
    "#{version} #{code} #{message}"
  end
    
  def length_header(body)
    "Content-Length: #{body.length}"
  end
  
  #given a status code and an optional message body, returns the HTTP response headers
  def headers(code, body = nil)
    head = status_line(code)
    head = "#{head}\n#{length_header(body)}" if body
    head
  end
  
  def sign_off(client)
    client.puts(Time.now.ctime) #now when puts to that socket, client picks up on other side.
    client.puts "Closing the connection. Bye!"
  end

  def run
    loop do
      client = @server.accept #instance method of TCPServer. waits for connection, returns TCPSocket representing that connection
      
      
      while line = client.gets
        puts line.chomp
        break if line =~ /^\s*$/
        request = Request.new(line) # parses the line into a Request
        if request.get? && request.path ~= /index\.html$/
          body = (File.open(index.html, 'r')).read
          head = headers(200, body)
          
          client.puts(headers)
          client.puts(body)
        elsif request.get? #we only have one html file, index.html, so it's requesting something else that doesn't exist
          client.print(headers(404))
         end
      end
      
      sign_off(client)
      client.close
    end
  end
  
end

#parses a string into the three parts of an HTML request
#TODO: make this work with a POST
class Request
  attr_reader :method, :path, :version
  def initialize(string)
    if string ~= /^GET/
      parts = string.split(" ") #an HTML GET is split by spaces
      @method = parts[0] #first part is GET
      @path = parts[1] #second part is the address
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
