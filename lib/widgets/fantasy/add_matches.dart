import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fc_ui/backend_config/config.dart';
import 'package:fc_ui/models/tournament_details.dart';
import 'package:fc_ui/services/fetch_tournaments.dart';

class AddMatches extends StatefulWidget {
  const AddMatches({super.key});
  @override
  State<AddMatches> createState() {
    return _AddMatchesState();
  }
}

class _AddMatchesState extends State<AddMatches> {
  final _formKey = GlobalKey<FormState>();
  List<TournamentDetails> _tournament = [];

  String? _selectedTeamA;
  String? _selectedTeamB;
  String? _selectedTournament;
  DateTime? _matchDate;
  var _isSending = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    try {
      final tournament = await fetchTournaments();
      setState(() {
        _tournament = tournament;
      });
      print(_tournament);
    } catch (error) {
      print('Error loading tournament: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tournament: $error')),
      );
    }
  }

  void _submitMatch() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      try {
        final url = Uri.parse(addMatchUrl);

        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "tournament_name": _selectedTournament,
            "team_A": {
              "team_name": _selectedTeamA,
              "team_short_name":
                  _tournament
                      .expand((tournament) => tournament.teams)
                      .firstWhere((team) => team.teamName == _selectedTeamA)
                      .teamShortName,
              "players":
                  _tournament
                      .expand((tournament) => tournament.teams)
                      .firstWhere((team) => team.teamName == _selectedTeamA)
                      .players
                      .map(
                        (player) => {
                          "player_name": player.playerName,
                          "player_short_name": player.playerShortName,
                          "player_role": player.playerRole,
                          "team_short_name":
                              _tournament
                                  .expand((tournament) => tournament.teams)
                                  .firstWhere(
                                    (team) => team.teamName == _selectedTeamA,
                                  )
                                  .teamShortName,
                          "credits": player.credits.toInt() ,
                        },
                      )
                      .toList(),
            },
            "team_B": {
              "team_name": _selectedTeamB,
              "team_short_name":
                  _tournament
                      .expand((tournament) => tournament.teams)
                      .firstWhere((team) => team.teamName == _selectedTeamB)
                      .teamShortName,
              "players":
                  _tournament
                      .expand((tournament) => tournament.teams)
                      .firstWhere((team) => team.teamName == _selectedTeamB)
                      .players
                      .map(
                        (player) => {
                          "player_name": player.playerName,
                          "player_short_name": player.playerShortName,
                          "player_role": player.playerRole,
                          "credits": player.credits,
                          "team_short_name":
                              _tournament
                                  .expand((tournament) => tournament.teams)
                                  .firstWhere(
                                    (team) => team.teamName == _selectedTeamB,
                                  )
                                  .teamShortName,
                          
                        },
                      )
                      .toList(),
            },
            "match_date": _matchDate?.toIso8601String(),
          }),
        );
        print(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newItem = json.decode(response.body);
          Navigator.pop(context, newItem);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                json.decode(response.body)['message'] ??
                    'Match Added successfully',
              ),
            ),
          );
        } else {
          setState(() {
            _isSending = false;
          });
        }
      } catch (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add Match')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Matches")),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              width: 2,
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedTournament,
                    items:
                        _tournament.map((tournament) {
                          return DropdownMenuItem<String>(
                            value: tournament.name,
                            child: Text(tournament.name),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTournament = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Tournament',
                      hintText: "Select Tournament",
                    ),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a tournament';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedTeamA,
                          items:
                              _tournament
                                  .where(
                                    (tournament) =>
                                        tournament.name == _selectedTournament,
                                  )
                                  .expand(
                                    (tournament) =>
                                        tournament.teams.map((team) {
                                          return DropdownMenuItem<String>(
                                            value: team.teamName,
                                            child: Text(team.teamName),
                                          );
                                        }),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == _selectedTeamB) {
                                // Swap the values if the selected value for Team B is the same as Team A
                                _selectedTeamB = null;
                              }
                              _selectedTeamA = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Teams',
                            hintText: "Select Team 1",
                          ),
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a tournament';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedTeamB,
                          items:
                              _tournament
                                  .where(
                                    (tournament) =>
                                        tournament.name == _selectedTournament,
                                  )
                                  .expand(
                                    (tournament) =>
                                        tournament.teams.map((team) {
                                          return DropdownMenuItem<String>(
                                            value: team.teamName,
                                            child: Text(team.teamName),
                                          );
                                        }),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == _selectedTeamA) {
                                // Swap the values if the selected value for Team B is the same as Team A
                                _selectedTeamA = null;
                              }
                              _selectedTeamB = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Teams',
                            hintText: "Select Team 2",
                          ),
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a team';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      if (_selectedTeamA != null)
                        Chip(
                          label: Text(_selectedTeamA!),
                          onDeleted: () {
                            setState(() {
                              _selectedTeamA = null;
                            });
                          },
                        ),
                      if (_selectedTeamB != null)
                        Chip(
                          label: Text(_selectedTeamB!),
                          onDeleted: () {
                            setState(() {
                              _selectedTeamB = null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      ' ${_matchDate != null ? _matchDate.toString().split(' ')[0] : DateTime.now().toString().split(' ')[0]}',
                    ),
                    leading: Text(
                      "Match Date:",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            _matchDate ??
                            DateTime.now(), // Use _matchDate if available, else today
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _matchDate) {
                        setState(() {
                          _matchDate = picked;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed:
                            _isSending
                                ? null
                                : () {
                                  _formKey.currentState!.reset();
                                  setState(() {
                                    _selectedTeamA = null;
                                    _selectedTeamB = null;
                                    _selectedTournament = null;
                                    _matchDate = null;
                                  });
                                },
                        child: Text("Reset"),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _isSending ? null : _submitMatch,
                        child:
                            _isSending
                                ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(),
                                )
                                : Text('Add Match'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}













//  DateTime? _matchDate;
//  "start_date": _matchDate?.toIso8601String(),
//  const SizedBox(height: 20),
//                  