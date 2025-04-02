import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fc_ui/backend_config/config.dart';
import 'package:fc_ui/models/team_details.dart';

Future<List<TeamDetails>> fetchTeams() async {
  final url = Uri.parse(getTeamsUrl);
  final response = await http.get(url);

  if (response.statusCode == 201) {
    List<dynamic> body = json.decode(response.body);
    List<TeamDetails> teams =
        body.map((dynamic item) => TeamDetails.fromJson(item)).toList();
    print(teams);

    return teams;
  } else {
    throw Exception('Failed to load teams');
  }
}
