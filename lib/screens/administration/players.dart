import 'package:flutter/material.dart';

import 'package:fc_ui/models/player_details.dart';
import 'package:fc_ui/services/fetch_players.dart';
import 'package:fc_ui/widgets/administration/players/add_players.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});
  @override
  State<PlayersScreen> createState() {
    return _PlayersScreenState();
  }
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<PlayerDetails> _players = [];
  var _isLoading = true;
  List<PlayerDetails> _filteredPlayers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlayers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayers() async {
    try {
      final player = await fetchPlayers();
      setState(() {
        _players = player;
        _filteredPlayers = player;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading teams: $error');
    }
  }

  void _addNewPlayer() async {
    final newPlayer = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => const AddPlayers()));

    if (newPlayer == null) {
      return;
    }
    _loadPlayers();
    setState(() {
      _players.add(newPlayer);
    });
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredPlayers = _players;
      });
    } else {
      setState(() {
        _filteredPlayers =
            _players
                .where(
                  (player) =>
                      player.playerName.toLowerCase().contains(query) ||
                      player.nationality.toLowerCase().contains(query),
                )
                .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<PlayerDetails>> playersByNationality = {};
    for (var player in _filteredPlayers) {
      if (!playersByNationality.containsKey(player.nationality)) {
        playersByNationality[player.nationality] = [];
      }
      playersByNationality[player.nationality]!.add(player);
    }
    return Scaffold(
      appBar: AppBar(title: Text("Players")),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Players Name or Nationality',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredPlayers.isEmpty
                    ? Center(
                      child: Text(
                        'No player found',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    )
                    : ListView(
                      children:
                          playersByNationality.keys.map((nationality) {
                            return ExpansionTile(
                              title: Text(
                                nationality.toUpperCase(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              children:
                                  playersByNationality[nationality]!.map((
                                    player,
                                  ) {
                                    return ListTile(
                                      title: Text(
                                        player.playerName.toUpperCase(),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium!.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        ),
                                      ),
                                      subtitle: Text(player.playerShortName),
                                    );
                                  }).toList(),
                            );
                          }).toList(),
                    ),
          ),
        ],
      ),

      // _isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : ListView(
      //       children:
      //           playersByNationality.keys.map((nationality) {
      //             return ExpansionTile(
      //               title: Text(nationality),
      //               children:
      //                   playersByNationality[nationality]!.map((player) {
      //                     return ListTile(
      //                       title: Text(player.playerName),
      //                       subtitle: Text(player.playerShortName),
      //                     );
      //                   }).toList(),
      //             );
      //           }).toList(),
      //     ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewPlayer,
        label: Text("+ Add Player"),
      ),
    );
  }
}
