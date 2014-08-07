require 'socket'

host = 'localhost' #the web server
port = 2001
path = "/index.html" #the file we want

#the HTTP request we send to fetch a file
request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(host, port) #connect
socket.print(request)   #send request
response = socket.read #read complete response

#split response at first blank line into headers and body
headers, body = response.split("\r\n\r\n", 2)
puts headers =~ (/200 OK/) ? body : headers
