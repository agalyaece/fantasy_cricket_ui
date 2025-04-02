import 'package:fc_ui/models/tournament_details.dart';
import 'package:fc_ui/services/fetch_tournaments.dart';
import 'package:fc_ui/widgets/administration/tournament/add_tournament.dart';
import 'package:flutter/material.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});
  @override
  State<TournamentScreen> createState() {
    return _TournamentScreenState();
  }
}

class _TournamentScreenState extends State<TournamentScreen> {
  List<TournamentDetails> _tournament = [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    try {
      final tournament = await fetchTournaments();
      setState(() {
        _tournament = tournament;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading tournament: $error');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tournament: $error')),
      );
    }
  }

  void _addTournament() async {
    final newTeam = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => const AddTournament()));

    if (newTeam == null) {
      return;
    }
    _loadTournaments();
    setState(() {
      _tournament.add(newTeam);
    });
  }

  Widget _buildTeamExpansionTile(TournamentDetails tournamentDetails) {
    return ExpansionTile(
      title: Text(
        tournamentDetails.name.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      children:
          tournamentDetails.teams.map((team) {
            return ListTile(
              title: Text(team.teamName.toUpperCase()),
              subtitle: Text(team.teamShortName),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tournaments")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _tournament.isEmpty
              ? Center(
                child: Text(
                  "No Tournament found",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              )
              : SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _tournament.length,
                  itemBuilder: (ctx, index) {
                    return _buildTeamExpansionTile(_tournament[index]);
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTournament,
        label: Text("+ Add Tournament"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
