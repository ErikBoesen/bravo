require 'tba'
require 'json'

# Initialize TBA API
tba = TBA.new('frc1418:bravo:v0.1.0')

print 'Enter event ID: '
# Recieve inputted event ID
event_id = gets.chomp
# Fetch event data from The Blue Alliance
event = tba.get_event(event_id)

print 'Enter team number to track: '
# Take inputted team number and convert it to an integer
team = gets.chomp.to_i
# Fetch matches that the team is in at this competition
matches = tba.get_team_matches(team, event_id)

# Make a new array to hold all the teams that played in those matches
teams = Array.new

# Go through each match and add all teams that played in those matches
matches.each do |match|
    # TODO: Dot notation?

    # Add red teams
    teams += match['alliances']['red']['teams']
    # Add blue teams
    teams += match['alliances']['blue']['teams']
end

# Remove duplicate teams from array.
teams.uniq!

# Create a new hash to store data about the teams
team_data = Hash.new

# Fetch the data for each team
teams.each do |team|
    # Create a new element containing the data of this team
    # (Turn string form [i.e. 'frc1418'] into integer, i.e. 1418)
    team_data[team] = tba.get_team(team[3..-1].to_i)
end

# Write team and match data into their respective files.
File.write('public/data/teams.json', JSON.generate(team_data))
File.write('public/data/matches.json', JSON.generate(matches))