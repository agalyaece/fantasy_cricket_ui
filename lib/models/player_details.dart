class PlayerDetails {
  const PlayerDetails({
    required this.id,
    required this.playerName,
    required this.nationality,
    required this.playerShortName,
    this.teams = const [],
    this.playerRole = const[],
    this.credits = 0,
  });

  final String id;
  final String playerName;
  final String nationality;
  final String playerShortName;
  final List<String> teams;
  final List<String> playerRole;
  final int credits;


  factory PlayerDetails.fromJson(Map<String, dynamic> json) {
    return PlayerDetails(
      id: json["_id"] ?? '',
      playerName: json["player_name"] ?? '',
      nationality: json["nationality"] ?? 0,
      playerShortName: json["player_short_name"] ?? '',
      teams: List<String>.from(json["teams"] ?? []),
      playerRole: List<String>.from(json["player_role"] ?? []),
      credits:json["credits"] ?? 0,
    );
  }
}
