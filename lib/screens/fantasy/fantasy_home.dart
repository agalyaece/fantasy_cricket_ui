import 'package:fc_ui/models/match_details.dart';
import 'package:fc_ui/screens/fantasy/join_matches.dart';
import 'package:fc_ui/services/fetch_matches.dart';
import 'package:fc_ui/widgets/fantasy/add_matches.dart';
import 'package:flutter/material.dart';

class FantasyHomeScreen extends StatefulWidget {
  const FantasyHomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _FantasyHomeScreenState();
  }
}

class _FantasyHomeScreenState extends State<FantasyHomeScreen> {
  List<MatchDetails> _matches = [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    try {
      final matches = await fetchMatches();
      setState(() {
        _matches = matches;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tournament: $error')),
      );
    }
  }

  void _addMatches() async {
    final newMatch = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => const AddMatches()));

    if (newMatch == null) {
      return;
    }
    _loadMatches();
    setState(() {
      _matches.add(newMatch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          
          Expanded(
            child: ListView.builder(
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final match = _matches[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(
                      Icons.sports_cricket,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.tournamentName,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        // const Divider(
                        //   color: Color.fromARGB(255, 6, 41, 70),
                        //   thickness: 0.3,
                        // ),
                        Text(
                          '${match.teamA[0].teamShortName}   vs   ${match.teamB[0].teamShortName}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(match.matchDate.toString().split(" ")[0]),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => JoinMatches(match: match),
                          ),
                        );
                      },
                      child: const Text('JOIN NOW'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMatches,
        label: Text("+ Add new Match"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
