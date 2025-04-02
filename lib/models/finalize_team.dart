import 'package:fc_ui/models/team_details.dart';

class FinalizeTeam {
  const FinalizeTeam({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.tournamentName,
    required this.matchDate,
    required this.players,
    required this.captain,
    required this.viceCaptain,

  });

  final String id;
  final String teamA;
  final String teamB;
  final String tournamentName;
  final DateTime matchDate;
  final List<PlayerDetails> players;
  final String captain;
  final String viceCaptain;

  factory FinalizeTeam.fromJson(Map<String, dynamic> json) {
    var playersList = json['players'] as List;
    List<PlayerDetails> players =
        playersList.map((i) => PlayerDetails.fromJson(i)).toList();

    return FinalizeTeam(
      id: json['_id'] ?? '',
      teamA: json['team_A'] ?? '',
      teamB: json['team_B'] ?? '',
      tournamentName: json['tournament_name'] ?? '',
      matchDate: DateTime.parse(json['match_date']),
      players: players,
      captain: json['captain'] ?? '',
      viceCaptain: json['vice_captain'] ?? '',
    );
  }
}