// const baseUrl = "http://192.168.1.2:3000/";
const baseUrl = "https://fantasy-cricket-ws.onrender.com/";

const addPlayerUrl = baseUrl + "administration/players/add_player";
const getPlayersUrl = baseUrl + "administration/players/get_players";

const addTeamsUrl = baseUrl + "administration/teams/add_team";
const getTeamsUrl = baseUrl + "administration/teams/get_teams";

const addTournamentsUrl =
    baseUrl + "administration//tournaments/add_tournament";
const getTournamentsUrl =
    baseUrl + "administration/tournaments/get_tournaments";

const addMatchUrl = baseUrl + "fantasy/matches/add_match";
const getMatchesUrl = baseUrl + "fantasy/matches/get_matches";


const addSelectedTeams = baseUrl + "fantasy/matches/create_team";
const getSelectedTeams = baseUrl + "fantasy/matches/get_selected_teams";