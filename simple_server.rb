require 'socket'


module SimpleServer

class Server

  def initialize
    @server = TCPServer.open(2001) #open method is the exact same as File.open. inherits from IO
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
    head += "\r\n\r\n"
    head
  end

  def run

    server = TCPServer.open(2000)
    loop do
      Thread.start(server.accept) do |client|
        p client
        request_raw = client.read_nonblock(256)
        p request_raw
        request = Request.new(request_raw) # parses the line into a Request
        p request
        if File.exist?(request.path)
          response_head = headers(200, body)
          response_body = (File.open(request.path, 'r')).read

          client.puts(head)
          client.puts(body)
        else
          client.puts(headers(404))
        end
        client.close
      end
    end
  end
end

#parses a string into the three parts of an HTML request
#TODO: make this work with a POST
class Request
  attr_reader :method, :path, :version, :body
  def initialize(string)
    header, @body = string.split("/r/r/n/n", 2)
    @method = header.split[0]
    @path = header.split[1]
    @version = header.split[2]
    puts @method, @path, @version, @body
  end

  def post?
    @method == "POST"
  end

  def get?
    @method == "GET"
  end
end

end

include SimpleServer
s = Server.new
s.run
