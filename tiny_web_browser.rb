require 'socket'

host = 'www.tutorialspoint.com' #the web server
port = 80 #default HTTP port
path = "/index.htm" #the file we want

#the HTTP request we send to fetch a file
request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(host, port) #connect
socket.print(request)   #send request
response = socket.read #read complete response

#split response at first blank line into headers and body
headers, body = response.split("\r\n\r\n", 2)
print body        #and display it
