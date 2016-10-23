require 'net/http'
require 'uri'
require 'json'

def fetch(url)
    JSON.parse(Net::HTTP.get(URI.parse(url)))
end

event = {}
loop do
    print 'Enter event ID: '
    event = fetch('https://www.thebluealliance.com/api/v2/event/' + gets.chomp + '/matches?X-TBA-App-Id=frc1418:bravo:v0.0.0')
    if !event.Errors
        puts 'That is not a valid event. Try again.'
        break;
    end
end

print 'Enter team number to track: '
teamNum = gets.chomp.to_i

matches = []

event.matches.each do |i|
    if event.matches[i].alliances.red.teams.include? 'frc1319' or event.matches[i].alliances.blue.teams.include? 'frc1319' then
        matches.push(i)
    end
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