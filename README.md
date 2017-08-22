# Bravo
Bravo is a live display for Team 1418's pit. It can:

* Show data about upcoming matches
* More features coming soon

## Dependencies
To install this application's dependencies, run

    pip3 install -r requirements.txt

from the `bravo` directory.

## Using
To prefetch data about a team for a competition, run:

    python3 fetch.py

This script will then ask for an event key (example: `2016cmp` for the 2016 championship, `2010sc` for the 2010 South Carolina/Palmetto Regional, or `2016vahay` for the 2016 Haymarket, Virginia District Event). Your event's key can be found by opening up the event's page on The Blue Alliance and looking in the URL bar.

Then, enter your team's number (for example, frc1418).

The script will then fetch and store data about the matches your team will participate in at that event, and the teams that you will compete with and against. This data is stored in `public/data` in files called `matches.json` and `teams.json`.

Next, run:

    python3 -m http.server 8000

This will start a simple server from which to host the dashboard.

## View
In your favorite browser, open:

    http://localhost:8000

That's it! See you in competition.

## License
Feel free to modify and use code under the terms of the [MIT License](LICENSE).
