import 'package:fc_ui/models/team_details.dart';

class MatchDetails {
 final String id; // Add an 'id' field for the tournament's ID
  final String tournamentName;
  final List<TeamDetails> teamA; 
  final List<TeamDetails> teamB;
    final DateTime matchDate;


  MatchDetails({
    required this.id,
    required this.tournamentName,
    required this.teamA,
    required this.teamB,
    required this.matchDate,
  }); 

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    var teamAList = json['team_A'] as List;
    List<TeamDetails> teamA =
        teamAList.map((i) => TeamDetails.fromJson(i)).toList();
    var teamBList = json['team_B'] as List;
    List<TeamDetails> teamB =
        teamBList.map((i) => TeamDetails.fromJson(i)).toList();
    return MatchDetails(
      id: json['_id']?? '', // Assuming your API returns the ID as '_id'
      tournamentName: json['tournament_name'],
      teamA: teamA, // Parse teams using Team.fromJson
      teamB: teamB,
      matchDate: DateTime.parse(json['match_date']),
    );
  }
}