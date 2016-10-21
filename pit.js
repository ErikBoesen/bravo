var ui = {
    panels: {
        red: document.getElementById('red'),
        blue: document.getElementById('blue')
    }
};

function Event(id) {
    this.id = id;
    var req = new XMLHttpRequest();
    req.open('GET', 'https://www.thebluealliance.com/api/v2/event/' + this.id + '/matches?X-TBA-App-Id=frc1418:bravo:v0.0.0', false);
    req.send();
    this.matches = JSON.parse(req.responseText);
}


var event = new Event('2010sc');

console.log(event);

var matches = [];

for (i = 0; i < event.matches.length; i++) {
    // TODO: Add option to specify the team you want to look for.
    if (event.matches[i].alliances.red.teams.indexOf('frc1319') != -1 ||
        event.matches[i].alliances.blue.teams.indexOf('frc1319') != -1) {

        matches.push(i);
    }
}

console.log(matches);

var teams = [];

for (i = 0; i < matches.length; i++) {
    for (j = 0; j < 3; i++) {
        console.log(event.matches[matches[i]]);
        var req = new XMLHttpRequest();
        req.open('GET', 'https://www.thebluealliance.com/api/v2/team/' + event.matches[matches[i]].alliances.red.teams[j] + '?X-TBA-App-Id=frc1418:bravodisplay:v0.0.0', false);
        req.send();
        console.log(req.responseText);
        teams[j] = JSON.parse(req.responseText);
        console.log(i);
    }

    ui.panels.red.innerHTML = 'JSON.stringify(teams)';
}
for (i = 0; i < matches.length; i++) {
    ui.panels.blue.innerHTML = 'test bluuu';
}