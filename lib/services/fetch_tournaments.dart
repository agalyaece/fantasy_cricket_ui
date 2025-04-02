import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fc_ui/backend_config/config.dart';
import 'package:fc_ui/models/tournament_details.dart';

Future<List<TournamentDetails>> fetchTournaments() async {
  final url = Uri.parse(getTournamentsUrl);
  final response = await http.get(url);

  if (response.statusCode == 201) {
    List<dynamic> body = json.decode(response.body);
    List<TournamentDetails> tournament =
        body.map((dynamic item) => TournamentDetails.fromJson(item)).toList();
    print(tournament);

    return tournament;
  } else {
    print(Exception());
    throw Exception('Failed to load tournament');
  }
}
