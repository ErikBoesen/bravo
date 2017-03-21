import tbapy
import json
from termcolor import colored as c


# Take inputted team number and convert it to an integer
track_team = int(input('Enter team number to track: '))

# Initialize TBA API
tba = tbapy.TBA('frc1418:bravo:v0.2.0')

event_id = input('Enter event ID: ')
# Recieve inputted event ID
# Fetch event data from The Blue Alliance
event = tba.event(event_id)

print('Getting Team #%s\'s matches at event %s...' % (track_team, event_id))
# Fetch matches that the team is in at this competition
matches = tba.team_matches(track_team, event_id)

# Sort matches
matches = sorted(matches, key=lambda match: (
    ['qm', 'qf', 'sf', 'f'].index(match['comp_level']), match['match_number']))

print('Getting stats for event %s...' % event_id)
# Fetch the team's stats
stats = {}

for key in tba.event_stats(event_id):
    stats[key] = tba.event_stats(event_id)

print('%d matches fetched and processed. Building team list... (may take a while)' %
      (len(matches)))

# Make a new array to hold all the teams that played in those matches
teams = []
temp = []
# Go through each match and add all teams that played in those matches
for match in matches:
    # Add red teams
    teams.append(match['alliances']['red']['teams'])
    # Add blue teams
    teams.append(match['alliances']['blue']['teams'])

# Flatten list and remove duplicates
teams = list(set([team for alliance in teams for team in alliance]))

# Create a new hash to store data about the teams
team_data = {}

# Fetch the data for each team
for team in teams:
    # Create a new element containing the data of this team
    # (Turn string form [i.e. 'frc1418'] into integer, i.e. 1418)
    team_data[team] = int(tba.team(team)['team_number'])
    print('Data fetched for team %s.' % (team[3:]))

print('Storing data...')

# Write team and match data into their respective files.
with open('public/data/teams.json', 'w+') as f:
    json.dump(team_data, f)

with open('public/data/matches.json', 'w+') as f:
    json.dump(matches, f)

with open('public/data/stats.json', 'w+') as f:
    json.dump(stats, f)

print('%s matches and %s teams fetched.' % (len(matches), len(teams)))
print('Tracking team %s, at event %s.' % (track_team, event_id))
print('Data saved in directory public/data/.')
