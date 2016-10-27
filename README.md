# Bravo
Bravo is a live display for Team 1418's pit. It can:

* Show data about upcoming matches
* More features coming soon

Bravo has not yet been used in competition but will be during the 2017 FIRST Steamworks season.

## Dependencies
To install this application's dependencies, run

    bundle install

from the `bravo` directory.

## Using
To prefetch data about a team for a competition, run:

    ruby fetch.rb

This script will then ask for an event key (example: `2016cmp` for the 2016 championship, `2010sc` for the 2010 South Carolina/Palmetto Regional, or `2016vahay` for the 2016 Haymarket, Virginia District Event). Your event's key can be found by opening up the event's page on The Blue Alliance and looking in the URL bar.

Then, enter your team's number.

The script will then fetch and store data about the matches your team will participate in at that event, and the teams that you will compete with and against. This data is stored in `public/data` in files called `matches.json` and `teams.json`.

Next, run:

    ruby server.rb

This will start a simple server from which to host the dashboard.

Open up

    http://localhost:8000

in your browser to view the dashboard.

## View
To view the dashboard, open `index.html` in your favorite browser.

## License
Feel free to modify and use code under the terms of the [MIT License](LICENSE).