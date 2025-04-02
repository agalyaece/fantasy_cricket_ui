import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fc_ui/models/player_details.dart';
import 'package:fc_ui/backend_config/config.dart';
import 'package:fc_ui/services/fetch_players.dart';

class AddTeams extends StatefulWidget {
  const AddTeams({super.key});
  @override
  State<AddTeams> createState() {
    return _AddTeamsState();
  }
}

class _AddTeamsState extends State<AddTeams> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTeamName = "";
  var _enteredTeamShortName = "";
  int _enteredCredits = 0;
  var _isSending = false;

  List<PlayerDetails> _players = [];
  PlayerDetails? _selectedPlayer;
  String? _selectedRole;
  List<Map<PlayerDetails, MapEntry<String, int>>> _teamPlayers = [];

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    try {
      final players = await fetchPlayers();
      setState(() {
        _players = players;
      });
      print('Fetched players: $_players');
    } catch (error) {
      print('Error fetching players: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load players: $error')));
    }
  }

  void _addPlayerToTeam() {
    if (_selectedPlayer != null &&
        _selectedRole != null &&
        _enteredCredits >= 1) {
      setState(() {
        _teamPlayers.add({
          _selectedPlayer!: MapEntry(_selectedRole!, _enteredCredits),
        });
        _selectedPlayer = null;
        _selectedRole = null;
        _enteredCredits = 0; // Reset credits after adding the player
      });
    }
  }

  void _submitTeam() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      try {
        final url = Uri.parse(addTeamsUrl);

        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "team_name": _enteredTeamName,
            "team_short_name": _enteredTeamShortName,
            "players":
                _teamPlayers
                    .map(
                      (player) => {
                        "player_name": player.keys.first.playerName,
                        "player_short_name": player.keys.first.playerShortName,
                        "player_role": player.values.first.key,
                        "credits": player.values.first.value,
                        "team_short_name": _enteredTeamShortName,
                      },
                    )
                    .toList(),
          }),
        );
        // print(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newItem = json.decode(response.body);
          Navigator.pop(context, newItem);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                json.decode(response.body)['message'] ??
                    'Team Added successfully',
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
        ).showSnackBar(SnackBar(content: Text('Failed to add player')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Team")),
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
                      labelText: 'Team',
                      hintText: "Team Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter valid characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredTeamName = value!;
                    },
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Short  Name',
                      hintText: "Short Team Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter valid characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredTeamShortName = value!;
                    },
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  SizedBox(height: 20),

                  DropdownButtonFormField<PlayerDetails>(
                    value: _selectedPlayer,
                    items:
                        _players.map((player) {
                          // print('Player Name in Dropdown: ${player.playerName}');
                          return DropdownMenuItem<PlayerDetails>(
                            value: player,
                            child: Text(player.playerName.toUpperCase()),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPlayer = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Select Player'),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          items:
                              <String>[
                                'WicketKeeper',
                                'Batter',
                                'Bowler',
                                'AllRounder',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                          decoration: InputDecoration(labelText: 'Select Role'),
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter Number',
                            hintText: '1-10',
                          ),
                          onSaved: (newValue) {
                            _enteredCredits = int.tryParse(newValue!) ?? 0;
                          },
                          onChanged: (newValue) {
                            setState(() {
                              _enteredCredits = int.tryParse(newValue) ?? 0;
                                 
                            });
                          },
                          initialValue: 0.toString(),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a number';
                            }
                            final number = int.tryParse(value);
                            if (number == null || number < 1 || number > 10) {
                              return 'Enter a number between 1 and 10';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        _selectedPlayer != null &&
                            _selectedRole != null &&
                            _enteredCredits >= 1
                          ? () {
                            _addPlayerToTeam();
                            setState(() {
                              _enteredCredits = 0; // Reset the credit field to empty
                            });
                            }
                          : null,
                    child: Text('Add Player to Team'),
                  ),
                  SizedBox(height: 20),
                  Text('Team Players:'),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate((_teamPlayers.length / 2).ceil(), (
                      index,
                    ) {
                      final playerRoleMap1 = _teamPlayers[index * 2];
                      final player1 = playerRoleMap1.keys.first;
                      final role1 = playerRoleMap1.values.first;
                      final playerRoleMap2 =
                          index * 2 + 1 < _teamPlayers.length
                              ? _teamPlayers[index * 2 + 1]
                              : null;
                      final player2 = playerRoleMap2?.keys.first;
                      final role2 = playerRoleMap2?.values.first;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(player1.playerName.toUpperCase()),
                              subtitle: Text(
                                'Role: ${role1.key} Credits: ${role1.value}',
                              ),
                            ),
                          ),
                          if (player2 != null)
                            Expanded(
                              child: ListTile(
                                title: Text(player2.playerName.toUpperCase()),

                                subtitle: Text(
                                  'Role: ${role2?.key} Credits: ${role2?.value}',
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),

                  SizedBox(height: 20),
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
                                    _selectedPlayer = null;
                                    _selectedRole = null;
                                    _teamPlayers = [];
                                  });
                                },
                        child: Text("Reset"),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _isSending ? null : _submitTeam,
                        child:
                            _isSending
                                ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(),
                                )
                                : Text('Add Team'),
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
