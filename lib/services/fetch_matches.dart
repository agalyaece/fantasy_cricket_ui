import 'package:fc_ui/backend_config/config.dart';
import 'package:fc_ui/models/match_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
Future<List<MatchDetails>> fetchMatches() async {
  final url = Uri.parse(getMatchesUrl);
  final response = await http.get(url);

  if (response.statusCode == 201) {
    List<dynamic> body = json.decode(response.body);
    List<MatchDetails> match =
        body.map((dynamic item) => MatchDetails.fromJson(item)).toList();
    // print(match);

    return match;
  } else {
    print(Exception());
    throw Exception('Failed to load match');
  }
}
