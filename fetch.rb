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

# TODO: There's almost certainly a better way to sort the array by match type.
# This method feels very heavy and innefficient. Find a better system.
# Perhaps something clever with matches.sort_by.

# Create new arrays to hold elimination matches
matches_qf = Array.new
matches_sf = Array.new
matches_f = Array.new

# Create array to hold elimination match indices in match array
matches_elim = Array.new

# Go through the match list.
matches.each_with_index do |match, i|
    # If a match is a quarterfinal, semifinal, or final match,
    # add it to the appropriate list and mark it for removal later on.
    case match["comp_level"]
        when "qf"
            # Add to quarterfinal match list
            matches_qf.push(match)
            # Add index of match to list of indices we created above
            matches_elim.push(i)
        when "sf"
            matches_sf.push(match)
            matches_elim.push(i)
        when "f"
            matches_f.push(match)
            matches_elim.push(i)
    end
end

# Go backwards through the list of indices of elimination matches.
matches_elim.reverse_each do |i|
    # Remove each of them.
    matches -= [matches[i]]
end

# Sort qualification matches by number.
matches.sort_by! do |match|
    match["match_number"]
end

# Combine qual matches with quarters, semis, and finals; but this time in order.
matches += matches_qf + matches_sf + matches_f

puts "#{matches.length} matches fetched and processes. Building team list... (this could take a while)"
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
    # Create a new element containing the data of this team
    # (Turn string form [i.e. "frc1418"] into integer, i.e. 1418)
    team_data[team] = tba.get_team(team[3..-1].to_i)
end

puts "Storing data..."

# Write team and match data into their respective files.
public = File.expand_path "../public", __FILE__
File.write(public + "/data/teams.json", JSON.pretty_generate(team_data))
File.write(public + "/data/matches.json", JSON.pretty_generate(matches))

puts "Done!"