import 'package:fc_ui/models/team_details.dart';
import 'package:fc_ui/services/fetch_teams.dart';
import 'package:fc_ui/widgets/administration/teams/add_teams.dart';
import 'package:flutter/material.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TeamsScreenState();
  }
}

class _TeamsScreenState extends State<TeamsScreen> {
  List<TeamDetails> _team = [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    try {
      final team = await fetchTeams();
      setState(() {
        _team = team;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading teams: $error');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load teams: $error')));
    }
  }

  void _addNewTeam() async {
    final newTeam = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => const AddTeams()));

    if (newTeam == null) {
      return;
    }
    _loadTeams();
    setState(() {
      _team.add(newTeam);
    });
  }

  Widget _buildTeamExpansionTile(TeamDetails teamDetails) {
    return ExpansionTile(
      title: Text(teamDetails.teamName.toUpperCase()),
      leading: CircleAvatar(child: Text(teamDetails.teamShortName)),
      children:
          teamDetails.players.map((player) {
            return ListTile(
              title: Text(player.playerName.toUpperCase()),
              subtitle: Text(
                ' ${player.playerShortName},  ${player.playerRole}, ${player.credits}',
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Squads")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _team.length,
                itemBuilder: (ctx, index) {
                  return _buildTeamExpansionTile(_team[index]);
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewTeam,
        label: Text("+ Add Team"),
      ),
    );
  }
}
