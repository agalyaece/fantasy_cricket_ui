import 'package:fc_ui/backend_config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fc_ui/models/team_details.dart';
import 'package:fc_ui/services/fetch_teams.dart';

class AddTournament extends StatefulWidget {
  const AddTournament({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AddTournamentState();
  }
}

class _AddTournamentState extends State<AddTournament> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTournamentName = "";
  List<TeamDetails> _availableTeams = [];
  Set<TeamDetails> _selectedTeams = {}; // Using a Set to prevent duplicates

  TeamDetails? _dropdownValue; //temp value for the dropdown.
  var _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    try {
      final team = await fetchTeams();
      setState(() {
        _availableTeams = team;
      });
      print(_availableTeams);
    } catch (error) {
      print('Error loading teams: $error');
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load teams: $error')));
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedTeams.length >= 2) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      try {
        final response = await http.post(
          Uri.parse(addTournamentsUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "name": _enteredTournamentName,
            "teams":
                _selectedTeams
                    .map(
                      (team) => {
                        "team_name": team.teamName,
                        "team_short_name": team.teamShortName,
                        "players":
                            team.players
                                .map(
                                  (player) => {
                                    "player_name": player.playerName,
                                    "player_role": player.playerRole,
                                    "player_short_name": player.playerShortName,
                                    "team_short_name": team.teamShortName,
                                    "credits": player.credits,
                                  },
                                )
                                .toList(),
                      },
                    )
                    .toList(),
          }),
        );
        // print(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newItem = json.decode(response.body);
          if (!mounted) return;
          Navigator.pop(context, newItem);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                json.decode(response.body)['message'] ??
                    'Tournament Added successfully',
              ),
            ),
          );
        } else {
          setState(() {
            _isSending = false;
          });
        }
      } catch (error) {
        setState(() {
          _isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      setState(() {
        _isSending = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least two teams.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Tournament")),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tournament',
                      hintText: "Tournament Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter valid characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredTournamentName = value!;
                    },
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),

                  const SizedBox(height: 20),
                  DropdownButtonFormField<TeamDetails>(
                    value: _dropdownValue,
                    items:
                        _availableTeams.map((team) {
                          return DropdownMenuItem<TeamDetails>(
                            value: team,
                            child: Text(team.teamName),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _dropdownValue = value;
                        if (value != null) {
                          _selectedTeams.add(value);
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Squads for this Tournament',
                    ),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    validator: (value) {
                      if (_selectedTeams.length < 2) {
                        return 'Select at least two teams';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children:
                        _selectedTeams
                            .map(
                              (team) => Chip(
                                label: Text(team.teamName),
                                onDeleted: () {
                                  setState(() {
                                    _selectedTeams.remove(team);
                                  });
                                },
                              ),
                            )
                            .toList(),
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
                                    _selectedTeams = {};
                                  });
                                },
                        child: Text("Reset"),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _isSending ? null : _submitForm,
                        child:
                            _isSending
                                ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(),
                                )
                                : Text('Add Tournament'),
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
