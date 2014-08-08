require 'socket'
require 'json'



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

def parse_status_line(string)
  header, @body = string.split("\r\n\r\n", 2)
  @method = header.split[0]
  @path = header.split[1].shift
  @version = header.split[2]
  @other_headers = header.split[3..-1] #just for now to test some things
  puts @method, @path, @version, @body
end




  server = TCPServer.open(2009)
  request = ""
  loop do
    client = server.accept       # Wait for a client to connect

    header = ""
    while line = client.gets
      header << line
      break if line =~ /^\s*$/
    end

    method = header.split[0]
    path = header.split[1][1..-1]

    p method, path

    if method == "POST"
      body = ""
      while line = client.gets
        body << line
        break if line =~ /^\s*$/
      end
      p body
    end


    if method == "GET" && File.exist?(path)

      response_body = (File.open(path, 'r')).read
      response_head = "HTTP/1.0 200 OK\nContent-Length: #{response_body.length}\r\n\r\n"

      client.puts(response_head)
      client.puts(response_body)
    else
      response_head = "HTTP/1.0 404 Not Found"
    end
    client.close
  end

#parses a string into the three parts of an HTML request
#TODO: make this work with a POST
#sample POST request: "POST /thanks.html HTTP/1.0\nFrom: blep@blap.bl\nContent-Type: application/json\n
#Content-Length: 50\n\r\n\r\n{\"viking\":{\"name\":\"Bob\",\"address\":\"blep@blap.bl\"}}\n"
