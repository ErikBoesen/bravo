import tbapi
import json
import os
import getpass
track_team = input("Enter team number to track: ")
# Take inputted team number and convert it to an integer


# Initialize TBA API
tba = tbapi.TBAParser("1418","bravo", "v0.1.0")

event_id = input("Enter event ID: ")
# Recieve inputted event ID
# Fetch event data from The Blue Alliance
event = tba.get_event(event_id)

print ("Getting Team #%s's matches at event #%s..." % (track_team, event_id))
# Fetch matches that the team is in at this competition
matches = tba.get_team_event_matches(track_team, event_id)

# Sort matches
matches = sorted(matches, key=lambda match: (['qm', 'qf', 'sf', 'f'].index(match.comp_level), match.match_number))

print ("Getting stats for event %s..." % (event_id))
# Fetch the team's stats
stats = {}
for Key in (tba.get_event_stats(event_id).raw):
    stats[Key] = (tba.get_event_stats(event_id)).raw

print ("%d matches fetched and processed. Building team list... (may take a while)" % (len(matches)))
# Make a new array to hold all the teams that played in those matches
teams = []
temp = []
# Go through each match and add all teams that played in those matches
for match in matches:
    # TODO: Dot notation/symbolization?

    # Add red teams
    teams += match.alliances['red']['teams']
    # Add blue teams
    teams += match.alliances['blue']['teams']


# Remove duplicate teams from array.
for team in teams:
    if team not in temp:
        temp.append(team)
teams = temp
    

# Create a new hash to store data about the teams
team_data = {}

# Fetch the data for each team
for team in teams:
    # Create a new element containing the data of this team
    # (Turn string form [i.e. "frc1418"] into integer, i.e. 1418)
    for Key in (tba.get_team(team)).raw:
        team_data[team] = (tba.get_team(team)).raw
    print ("Data fetched for team %s" % (team))

print ("Storing data...")

# Write team and match data into their respective files.
with open('public/data/teams.json','w+') as team_data_file:
    json.dump(team_data, team_data_file)
with open('public/data/matches.json','w+') as team_matches_file:
    for n in matches:
        json.dump(n.raw, team_matches_file)

with open('public/data/stats.json','w+') as team_stats_file:
    json.dump(stats, team_stats_file)

print (len(matches) , " Matches")
print (len(teams), " Teams")
print ("Tracking team %s, at event %s" % (track_team, event_id))
print ("Data saved in folder public/data/")



