// Alias oft-used parts of the interface.
var ui = {
    panels: {
        match: {
            number: document.getElementById('match-number')
        },
        red: document.getElementById('red'),
        blue: document.getElementById('blue')
    },
    arrow: {
        previous: document.getElementById('previous'),
        next: document.getElementById('next')
    },
    fist: document.getElementById('fist')
};

// Fetch pregenerated match data
var getMatches = new XMLHttpRequest();
getMatches.open('GET', '/static/data/matches.json', false);
getMatches.send();
var matches = JSON.parse(getMatches.responseText);

// Fetch pregenerated team data
var getTeams = new XMLHttpRequest();
getTeams.open('GET', '/static/data/teams.json', false);
getTeams.send();
var teams = JSON.parse(getTeams.responseText);

// Fetch pregenerated team stats
var getStats = new XMLHttpRequest();
getStats.open('GET', '/static/data/stats.json', false);
getStats.send();
var stats = JSON.parse(getStats.responseText);

var currentMatch = 0;

function render(match) {
    // Alias the lists of red teams and blue teams
    red = matches[match].alliances.red.teams;
    redData = [];
    blue = matches[match].alliances.blue.teams;
    blueData = [];

    oprs = stats.oprs;
    // Go through the list and store that team's data in redData.
    for (i = 0; i < 3; i++) {
        redData[i] = teams[red[i]];
        blueData[i] = teams[blue[i]];
        // If 1418 is on this alliance, make the fist in the center be red.
        if (redData[i].team_number === 1418) ui.fist.style.fill = '#d12727';
        else if (blueData[i].team_number === 1418) ui.fist.style.fill = '#156bde';
    }

    ui.panels.match.number.innerHTML = 'Match ' + matches[match].comp_level.toUpperCase() + matches[match].match_number;
    // Set the contents of the panels.
    // TODO: Use DOM manipulation methods instead of innerHTML (better security)
    // TODO: Make this less messy.
    ui.panels.red.innerHTML = '<h1>Predicted Score: ~' + Math.round(oprs[parseFloat(red[0].substring(3))] + oprs[parseFloat(red[1].substring(3))] + oprs[parseFloat(red[2].substring(3))]) + '</h1>';
    ui.panels.blue.innerHTML = '<h1>Predicted Score: ~' + Math.round(oprs[parseFloat(blue[0].substring(3))] + oprs[parseFloat(blue[1].substring(3))] + oprs[parseFloat(blue[2].substring(3))]) + '</h1>';
    for (i = 0; i < 3; i++) {
        ui.panels.red.innerHTML +=
            '<div>' +
                '<h2>' + red[i].substring(3) + ' | ' + redData[i].nickname + '</h2>' +
                '<ul>' +
                    '<li>OPR: ' + Math.round(oprs[parseFloat(red[i].substring(3))]) + ' Points</li>' +
                    '<li>Location: ' + redData[i].location + '</li>' +
                '</ul>' +
            '</div>';
        ui.panels.blue.innerHTML +=
            '<div>' +
                '<h2>' + blue[i].substring(3) + ' | ' + blueData[i].nickname + '</h2>' +
                '<ul>' +
                  '<li>OPR: ' + Math.round(oprs[parseFloat(blue[i].substring(3))]) + ' Points</li>' +
                    '<li>Location: ' + blueData[i].location + '</li>' +
                '</ul>' +
            '</div>';
    }
}

// Once function is declared, render data from the first match.
render(0);

// Listeners for arrow buttons being clicked on.
ui.arrow.previous.onclick = function() {
    // If there are any previous matches left...
    if (currentMatch > 0) {
        // Switch to the previous one and rerender data.
        currentMatch--;
        render(currentMatch);
    }
};
ui.arrow.next.onclick = function() {
    // If there are any more matches left...
    if (currentMatch < matches.length - 1) {
        // Switch to the next one and rerender data.
        currentMatch++;
        render(currentMatch);
    }
};
