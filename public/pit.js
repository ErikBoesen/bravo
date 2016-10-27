// Alias oft-used parts of the interface.
var ui = {
    panels: {
        red: document.getElementById('red'),
        blue: document.getElementById('blue')
    },
    fist: document.getElementById('fist')
};

// Fetch pregenerated match data
var getMatches = new XMLHttpRequest();
getMatches.open('GET', 'data/matches.json', false);
getMatches.send();
var matches = JSON.parse(getMatches.responseText);

// Fetch pregenerated team data
var getTeams = new XMLHttpRequest();
getTeams.open('GET', 'data/teams.json', false);
getTeams.send();
var teams = JSON.parse(getTeams.responseText);

// Alias the lists of red teams and blue teams
// TODO: Figure out what the next match is instead of defaulting to the first one! The whole dashboard is kind of pointless if that doesn't happen.
red = matches[0].alliances.red.teams;
redData = [];
blue = matches[0].alliances.blue.teams;
blueData = [];
// Go through the list and store that team's data in redData.
for (i = 0; i < 3; i++) {
    redData[i] = teams[red[i]];
    blueData[i] = teams[blue[i]];
    // Turn the team number into an integer
    // TODO: Find better way of converting 'frc####' to an int of the team number.
    red[i] = parseInt(red[i].substring(3, red[i].length));
    blue[i] = parseInt(blue[i].substring(3, red[i].length));
    // If 1418 is on this alliance, make the fist in the center be red.
    if (red[i] === 1418) ui.fist.style.fill = '#d12727';
    else if (blue[i] === 1418) ui.fist.style.fill = '#156bde';
}

// Set the contents of the panels.
// TODO: Use DOM manipulation methods instead of innerHTML (better security)
// TODO: Calculate OPRs and predicted scores.
ui.panels.red.innerHTML = '<h1>Predicted Score: ???</h1>';
ui.panels.blue.innerHTML = '<h1>Predicted Score: ???</h1>';
for (i = 0; i < 3; i++) {
    ui.panels.red.innerHTML +=
        '<div>' +
            '<h2>' + red[i] + '</h2>' +
            '<ul>' +
                '<li>OPR: ??? Points</li>' +
                '<li>Location: ' + redData[i].location + '</li>' +
            '</ul>' +
        '</div>';
    ui.panels.blue.innerHTML +=
        '<div>' +
            '<h2>' + blue[i] + '</h2>' +
            '<ul>' +
                '<li>OPR: ??? Points</li>' +
                '<li>Location: ' + blueData[i].location + '</li>' +
            '</ul>' +
        '</div>';
}