require 'net/http'
require 'uri'
require 'json'

def fetch(url)
    JSON.parse(Net::HTTP.get(URI.parse(url)))
end

event = Array.new
print 'Enter event ID: '
event = fetch('https://www.thebluealliance.com/api/v2/event/' + gets.chomp + '/matches?X-TBA-App-Id=frc1418:bravo:v0.0.0')

puts event

print 'Enter team number to track: '
#teamNum = gets.chomp.to_i
teamNum = 1319

matches = Array.new



# TBA matches requests are returned as an array, the 0th element of which is a hash of the actual match data
event[0].each do |i|
=begin
    puts event[0]
    if event[0][i].alliances.red.teams.include? 'frc1319' or event[0][i].alliances.blue.teams.include? 'frc1319'
        matches.push(i)
    end
=end
end

puts matches

teams = []

matches.each do |i|
    3.times do |j|
        puts event.matches[matches[i]]
        teams[j] = fetch('https://www.thebluealliance.com/api/v2/team/' + event.matches[matches[i]].alliances.red.teams[j] + '?X-TBA-App-Id=frc1418:bravo:v0.0.0');
    end
end

# TODO: Also gather data for Blue alliances.