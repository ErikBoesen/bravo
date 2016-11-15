require "webrick"
require "pathname"
require "colorize"

unless Pathname('data/teams.json').exist? && Pathname('data/matches.json').exist? && Pathname('data/stats.json').exist?
    puts "WARNING:".red + " It looks like you haven't fetched match data yet. Make sure to run fetch.rb before using Bravo."
end

# Open a basic webserver.
root = File.expand_path "../public", __FILE__
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root
trap "INT" do server.shutdown end

server.start