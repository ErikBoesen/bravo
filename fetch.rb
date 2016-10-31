require "tba"
require "json"

print "Enter team number to track: "
# Take inputted team number and convert it to an integer
team = gets.chomp.to_i

# Initialize TBA API
tba = TBA.new("frc#{team}:bravo:v0.1.0")

print "Enter event ID: "
# Recieve inputted event ID
event_id = gets.chomp
# Fetch event data from The Blue Alliance
event = tba.get_event(event_id)


puts "Getting Team #{team}'s matches at event #{event_id}..."
# Fetch matches that the team is in at this competition
matches = tba.get_team_matches(team, event_id)

# Sort matches
matches.sort_by! do |match|
    # First sort by type of match, then by match number.
    [["qm", "qf", "sf", "f"].find_index(match["comp_level"]), match["match_number"]]
end

puts "Getting stats for event #{event_id}..."
# Fetch the team's stats
stats = tba.get_event_stats(event_id)

puts "#{matches.length} matches fetched. Building team list... (this could take a while)"
# Make a new array to hold all the teams that played in those matches
teams = Array.new

# Go through each match and add all teams that played in those matches
matches.each do |match|
    # TODO: Dot notation/symbolization?

    # Add red teams
    teams += match["alliances"]["red"]["teams"]
    # Add blue teams
    teams += match["alliances"]["blue"]["teams"]
end

# Remove duplicate teams from array.
teams.uniq!

# Create a new hash to store data about the teams
team_data = Hash.new

# Fetch the data for each team
teams.each do |team|
    print "Fetching data for #{team}..."
    # Create a new element containing the data of this team
    # (Turn string form [i.e. "frc1418"] into integer, i.e. 1418)
    team_data[team] = tba.get_team(team[3..-1].to_i)
    puts "done."
end

puts "Storing data..."

# Write team and match data into their respective files.
public = File.expand_path "../public", __FILE__
File.write(public + "/data/teams.json", JSON.pretty_generate(team_data))
File.write(public + "/data/matches.json", JSON.pretty_generate(matches))
File.write(public + "/data/stats.json", JSON.pretty_generate(stats))

puts "Data saved, ready to run!"
