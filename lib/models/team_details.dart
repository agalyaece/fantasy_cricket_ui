class PlayerDetails {
  final String playerName;
  final String playerShortName;
  final String playerRole;
  final int credits;
  final String teamShortName;
  bool isCaptain; // Add this field
  bool isViceCaptain;

  PlayerDetails({
    required this.playerName,
    required this.playerShortName,
    required this.playerRole,
    required this.credits,
    required this.teamShortName,
    this.isCaptain = false, // Initialize with default value
    this.isViceCaptain = false,
  });

  factory PlayerDetails.fromJson(Map<String, dynamic> json) {
    return PlayerDetails(
      playerName: json['player_name'],
      playerShortName: json['player_short_name'],
      playerRole: json['player_role'],
      credits: json['credits'] ?? 0,
      teamShortName: json['team_short_name'] ?? '',
      isCaptain: json['is_captain'] ?? false,
      isViceCaptain: json['is_vice_captain'] ?? false,
    );
  }
}

class TeamDetails {
  final String id;

  final String teamName;
  final String teamShortName;
  final List<PlayerDetails> players;

  TeamDetails({
    required this.id,

    required this.teamName,
    required this.teamShortName,
    required this.players,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamDetails &&
          runtimeType == other.runtimeType &&
          id == other.id; // Compare by ID

  @override
  int get hashCode => id.hashCode;
  factory TeamDetails.fromJson(Map<String, dynamic> json) {
    var playersList = json['players'] as List;
    List<PlayerDetails> players =
        playersList.map((i) => PlayerDetails.fromJson(i)).toList();

    return TeamDetails(
      id: json["_id"],
      teamName: json['team_name'] ?? '',
      teamShortName: json['team_short_name'] ?? '',
      players: players,
    );
  }
}
