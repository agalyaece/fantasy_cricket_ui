import 'package:fc_ui/models/match_details.dart';
import 'package:fc_ui/models/team_details.dart';
import 'package:fc_ui/widgets/fantasy/finalize_team.dart';
import 'package:flutter/material.dart';
import 'package:progress_stepper/progress_stepper.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

class CreateTeam extends StatefulWidget {
  final MatchDetails match;
  const CreateTeam({super.key, required this.match});
  @override
  State<StatefulWidget> createState() {
    return _CreateTeamState();
  }
}

class _CreateTeamState extends State<CreateTeam> {
  List<PlayerDetails> selectedPlayers = [];
  int selectedTabIndex = 0;
  String? captain;
  String? viceCaptain;
  double totalCredits = 0;
  final double creditLimit = 100;
  int teamACount = 0;
  int teamBCount = 0;

  void addPlayer(player) {
    setState(() {
      final categoryCounts = {
        'WicketKeeper':
            selectedPlayers.where((p) => p.playerRole == 'WicketKeeper').length,
        'Batter': selectedPlayers.where((p) => p.playerRole == 'Batter').length,
        'Bowler': selectedPlayers.where((p) => p.playerRole == 'Bowler').length,
        'AllRounder':
            selectedPlayers.where((p) => p.playerRole == 'AllRounder').length,
      };

      if (selectedPlayers.length < 11 &&
          !selectedPlayers.contains(player) &&
          totalCredits + player.credits <= creditLimit &&
          (player.teamShortName == widget.match.teamA.first.teamShortName &&
                  teamACount < 10 ||
              player.teamShortName == widget.match.teamB.first.teamShortName &&
                  teamBCount < 10) &&
          categoryCounts[player.playerRole]! < 8) {
        selectedPlayers.add(player);
        totalCredits += player.credits;
        if (player.teamShortName == widget.match.teamA.first.teamShortName) {
          teamACount++;
        } else {
          teamBCount++;
        }
      }
    });
    for (var player in selectedPlayers) {
      print('Name: ${player.playerName}, Role: ${player.playerRole}, Team: ${player.teamShortName}, Credits: ${player.credits}');
    }
    print('credits: $totalCredits');

    final categoryCounts = {
      'WicketKeeper':
          selectedPlayers.where((p) => p.playerRole == 'WicketKeeper').length,
      'Batter': selectedPlayers.where((p) => p.playerRole == 'Batter').length,
      'Bowler': selectedPlayers.where((p) => p.playerRole == 'Bowler').length,
      'AllRounder':
          selectedPlayers.where((p) => p.playerRole == 'AllRounder').length,
    };

    if (selectedPlayers.length == 11 &&
        categoryCounts.values.any((count) => count == 0)) {
      setState(() {
        selectedPlayers.remove(player);
        totalCredits -= player.credits;
        if (player.teamShortName == widget.match.teamA.first.teamShortName) {
          teamACount--;
        } else {
          teamBCount--;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Each category must have at least one player.'),
        ),
      );
      // print('Each category must have at least one player.');
    }

  }

  void removePlayer(player) {
    setState(() {
      if (selectedPlayers.contains(player)) {
        selectedPlayers.remove(player);
        totalCredits -= player.credits;
        if (player.teamShortName == widget.match.teamA.first.teamShortName) {
          teamACount--;
        } else {
          teamBCount--;
        }
      }
      if (captain == player) {
        captain = null;
      }
      if (viceCaptain == player) {
        viceCaptain = null;
      }
    });
  }

  void _clearTeam() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Team'),
          content: const Text(
            'Are you sure you want to clear the selected team?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedPlayers.clear();
                  totalCredits = 0;
                  teamACount = 0;
                  teamBCount = 0;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
          child: Column(
            children: [
              Text(
                '${widget.match.teamA.first.teamShortName.toUpperCase()} - ${widget.match.teamB.first.teamShortName.toUpperCase()}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${selectedPlayers.length}/11',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ProgressStepper(
                    width: 300,
                    height: 20,
                    padding: 1,
                    stepCount: 11,
                    currentStep: selectedPlayers.length,
                    color: Colors.grey,
                    progressColor: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: _clearTeam,
                  ),
                ],
              ),

              Text(
                ' Credits: $totalCredits/$creditLimit',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: Colors.white),
              ),
              const Divider(color: Colors.grey, thickness: 1),
              Text(
                'Pick 11 players across categories.',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ScrollableListTabView(
              tabs: List.generate(
                4,
                (index) => ScrollableListTab(
                  tab: ListTab(
                    label: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),

                      child: Text(
                        [
                          'Wicket-Keepers',
                          'Batters',
                          'Bowlers',
                          'All Rounders',
                        ][index],
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  body: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        [
                          ...widget.match.teamA.first.players.where((player) {
                            switch (index) {
                              case 0:
                                return player.playerRole == 'WicketKeeper';
                              case 1:
                                return player.playerRole == 'Batter';
                              case 2:
                                return player.playerRole == 'Bowler';
                              case 3:
                                return player.playerRole == 'AllRounder';
                              default:
                                return false;
                            }
                          }),
                          ...widget.match.teamB.first.players.where((player) {
                            switch (index) {
                              case 0:
                                return player.playerRole == 'WicketKeeper';
                              case 1:
                                return player.playerRole == 'Batter';
                              case 2:
                                return player.playerRole == 'Bowler';
                              case 3:
                                return player.playerRole == 'AllRounder';
                              default:
                                return false;
                            }
                          }),
                        ].length,
                    itemBuilder: (context, playerIndex) {
                      final players = [
                        ...widget.match.teamA.first.players.where((player) {
                          switch (index) {
                            case 0:
                              return player.playerRole == 'WicketKeeper';
                            case 1:
                              return player.playerRole == 'Batter';
                            case 2:
                              return player.playerRole == 'Bowler';
                            case 3:
                              return player.playerRole == 'AllRounder';
                            default:
                              return false;
                          }
                        }),
                        ...widget.match.teamB.first.players.where((player) {
                          switch (index) {
                            case 0:
                              return player.playerRole == 'WicketKeeper';
                            case 1:
                              return player.playerRole == 'Batter';
                            case 2:
                              return player.playerRole == 'Bowler';
                            case 3:
                              return player.playerRole == 'AllRounder';
                            default:
                              return false;
                          }
                        }),
                      ];
                      final player = players[playerIndex];

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(player.teamShortName),
                        ),
                        title: Text('${player.playerShortName} '),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${player.credits} Credits'),
                            const SizedBox(width: 8),
                            selectedPlayers.contains(player)
                                ? IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => removePlayer(player),
                                )
                                : IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                  ),
                                  onPressed: () => addPlayer(player),
                                ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // onTabIndexChanged: (index) {
              //   setState(() {
              //     selectedTabIndex = index;
              //   });
              // },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (selectedPlayers.length == 11) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => FinalizeTeam(
                            selectedPlayers: selectedPlayers,
                            match: widget.match,
                            // captain: captain,
                            // viceCaptain: viceCaptain,
                          ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Select 11 players to finalize team.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Finalize Team'),
            ),
          ),
        ],
      ),
    );
  }
}
