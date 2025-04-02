import 'package:fc_ui/backend_config/config.dart';
import 'package:fc_ui/models/match_details.dart';
import 'package:fc_ui/models/team_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FinalizeTeam extends StatefulWidget {
  final List<PlayerDetails> selectedPlayers;
  final MatchDetails match;
  const FinalizeTeam({
    super.key,
    required this.selectedPlayers,
    required this.match,
  });

  @override
  State<FinalizeTeam> createState() => _FinalizeTeamState();
}

class _FinalizeTeamState extends State<FinalizeTeam> {
  var _isSending = false;

  void _finalizeTeam() async {
    int captainCount = widget.selectedPlayers.where((p) => p.isCaptain).length;
    int viceCaptainCount =
        widget.selectedPlayers.where((p) => p.isViceCaptain).length;

    if (captainCount != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select exactly one Captain")),
      );
      return;
    }

    if (viceCaptainCount != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select exactly one Vice-Captain")),
      );
      return;
    }
    final url = Uri.parse(addSelectedTeams);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "team_A": widget.match.teamA,
        "team_B": widget.match.teamB,
        "tournament_name": widget.match.tournamentName,
        "match_date": widget.match.matchDate,
        "players":
            widget.selectedPlayers.map((player) {
              return {
                "player_name": player.playerName,
                "player_short_name": player.playerShortName,
                "player_role": player.playerRole,
                "credits": player.credits,
                "team_short_name": player.teamShortName,
                "is_captain": player.isCaptain,
                "is_vice_captain": player.isViceCaptain,
              };
            }).toList(),
        "captain":
            widget.selectedPlayers
                .firstWhere((p) => p.isCaptain)
                .playerShortName,
        "vice_captain":
            widget.selectedPlayers
                .firstWhere((p) => p.isViceCaptain)
                .playerShortName,
      }),
    );
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final newItem = json.decode(response.body);
      Navigator.pop(context, newItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            json.decode(response.body)['message'] ?? 'Match Added successfully',
          ),
        ),
      );
    } else {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finalize Team"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select Captain and Vice-Captain",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.selectedPlayers.any((p) => p.isCaptain)
                          ? "Captain: ${widget.selectedPlayers.firstWhere((p) => p.isCaptain).playerShortName}"
                          : "Captain",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    height: 20, // Set the height for the VerticalDivider
                    child: VerticalDivider(
                      color: Colors.white,
                      thickness: 0.5, // Adjust thickness as needed
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    widget.selectedPlayers.any((p) => p.isViceCaptain)
                        ? "Vice-Captain: ${widget.selectedPlayers.firstWhere((p) => p.isViceCaptain).playerShortName}"
                        : "Vice-Captain",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.selectedPlayers.length,
        itemBuilder: (context, index) {
          final player = widget.selectedPlayers[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(player.playerName),
              subtitle: Text(player.playerRole),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Clear previous captain
                        for (var p in widget.selectedPlayers) {
                          p.isCaptain = false;
                        }
                        if (!player.isViceCaptain) {
                          player.isCaptain = true;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Player cannot be both Captain and Vice-Captain",
                              ),
                            ),
                          );
                        }
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor:
                          player.isCaptain ? Colors.green : Colors.grey[500],
                      radius: 16,
                      child: Text(
                        'C',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Clear previous vice-captain
                        for (var p in widget.selectedPlayers) {
                          p.isViceCaptain = false;
                        }
                        if (!player.isCaptain) {
                          player.isViceCaptain = true;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Player cannot be both Captain and Vice-Captain",
                              ),
                            ),
                          );
                        }
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor:
                          player.isViceCaptain ? Colors.blue : Colors.grey[400],
                      radius: 16,
                      child: Text(
                        'VC',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _finalizeTeam,
        label: Text("Finalize team"),
        icon:
            _isSending
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.check),
      ),
    );
  }
}
