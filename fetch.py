import tbapy
import json
import yaml


def main():
    # Load config
    with open('config.yml', 'r') as f:
        cfg = yaml.load(f)

    fetch(cfg['team'], cfg['event'], cfg['tba_token'])


def fetch(team, event, token):
    """
    Fetch and store TBA data for use on dashboard.

    :param team: Team to tailor data to.
    :param event: Key of event to get data on.
    :param token: TBA token to use for fetching data.
    """
    # Initialize TBA API
    tba = tbapy.TBA(token)

    print('Getting Team #{team}\'s matches at event {event}...'.format(team=team,
                                                                       event=event))
    # Fetch matches that the team is in at this competition
    matches = tba.team_matches(team, event)

    # Sort matches
    matches = sorted(matches, key=lambda match: (['qm', 'qf', 'sf', 'f'].index(match.comp_level), match.match_number))

    print('Getting stats for event {event}...'.format(event=event))
    # Fetch the event's stats
    stats = {'oprs': tba.event_oprs(event).oprs}

    print('{num_matches} matches fetched and processed. Building team list... (may take a while)'.format(num_matches=len(matches)))

    # Make a new array to hold all the teams that played in those matches
    teams = [match.alliances['red']['team_keys'] + match.alliances['blue']['team_keys'] for match in matches]
    # Flatten list and remove duplicates
    teams = list(set([tm for alliance in teams for tm in alliance]))
    # Create a new hash to store data about the teams
    team_data = {}

    # Fetch the data for each team
    for tm in teams:
        # Create a new element containing the data of this team
        # (Turn string form [i.e. 'frc1418'] into integer, i.e. 1418)
        team_data[tm] = int(tba.team(tm).team_number)
        print('Data fetched for team {team}.'.format(team=tm[3:]))

    print('Storing data...')

    # Write team and match data into their respective files.
    with open('public/data/teams.json', 'w+') as f:
        json.dump(team_data, f)
    with open('public/data/matches.json', 'w+') as f:
        json.dump(matches, f)
    with open('public/data/stats.json', 'w+') as f:
        json.dump(stats, f)

    print('{num_matches} matches and {num_teams} teams fetched.'.format(num_matches=len(matches),
                                                                        num_teams=len(teams)))
    print('Data saved in directory public/data/.')


if __name__ == '__main__':
    main()
