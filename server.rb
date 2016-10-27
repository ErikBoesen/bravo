require 'webrick'

# Open a basic webserver.
root = File.expand_path './public'
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root
trap 'INT' do server.shutdown end

server.start