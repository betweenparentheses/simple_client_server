require 'socket'
require 'json'

host = 'localhost' #the web server
port = 2001
path = "/index.html" #the file we want


puts "Welcome to your tiny web browser!"
puts "Do you want to try a GET or a POST request?"
print "> "
choice = gets.chomp.upcase
until choice == "GET" || choice == "POST"
  puts "Your choices are GET or POST."
  print "> "
  choice = gets.chomp.upcase
end


case choice
when "GET" then
  path = "/index.html"
  request = "GET #{path} HTTP/1.0\r\n\r\n"
when "POST"
  path = "/thanks.html"
  puts "Welcome to the Viking Raid Registration Form!"
  print "Please enter your Viking's name: "
  name = gets.chomp
  print "Please enter your Viking's e-mail address: "
  address = gets.chomp
end

#packs up data into a JSON for the request
viking_hash = {viking: {name: name, address: address}}
viking_json = viking_hash.to_json

#set up post request
request = <<POST_REQUEST
POST #{path} HTTP/1.0
From: #{address}
Content-Type: application/json
Content-Length: #{viking_json.length}

#{viking_json}
POST_REQUEST


#connects, requests and gets the whole response
socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read

#split response at first blank line into headers and body
headers, body = response.split("\r\n\r\n", 2)

#if response works, prints body, otherwise shows the errors
puts headers =~ (/200 OK/) ? body : headers
