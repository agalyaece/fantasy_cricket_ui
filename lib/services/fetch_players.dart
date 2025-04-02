import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fc_ui/backend_config/config.dart';
import 'package:fc_ui/models/player_details.dart';

Future<List<PlayerDetails>> fetchPlayers() async {
  try {
    final url = Uri.parse(getPlayersUrl);
    final response = await http.get(url);

    if (response.statusCode != 201) {
      throw Exception('Failed to load teams');
    }
    final List<dynamic> extractedData = json.decode(response.body);

    final List<PlayerDetails> _loadedItems =
        extractedData.map((item) => PlayerDetails.fromJson(item)).toList();
    return _loadedItems;
  } catch (error) {
    throw error;
  }
}
