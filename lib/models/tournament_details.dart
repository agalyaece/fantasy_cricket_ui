import 'package:fc_ui/models/team_details.dart';

class TournamentDetails {
  final String id; // Add an 'id' field for the tournament's ID
  final String name;
  final List<TeamDetails> teams; // Use the Team model here

  TournamentDetails({
    required this.id,
    required this.name,
    required this.teams,
  });

  // Factory method to create a Tournament object from a JSON map (for API responses)
  factory TournamentDetails.fromJson(Map<String, dynamic> json) {
    var teamsList = json['teams'] as List;
    List<TeamDetails> teams =
        teamsList.map((i) => TeamDetails.fromJson(i)).toList();

    //     DateTime? parsedStartDate; // Declare as nullable

    // if (json['start_date'] != null) {
    //   try {
    //     parsedStartDate = DateTime.parse(json['start_date']);
    //   } catch (e) {
    //     print('Error parsing start_date: $e');
    //     parsedStartDate = null; // Set to null on parse error
    //   }
    // }


    return TournamentDetails(
      id: json['_id']?? '', // Assuming your API returns the ID as '_id'
      name: json['name'],
      teams: teams, // Parse teams using Team.fromJson
      // startDate: parsedStartDate ?? DateTime.now(),
    );
  }
}
