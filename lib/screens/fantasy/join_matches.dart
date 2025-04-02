import 'package:fc_ui/models/match_details.dart';
import 'package:fc_ui/widgets/fantasy/create_team.dart';
import 'package:flutter/material.dart';

class JoinMatches extends StatefulWidget {
  final MatchDetails match;
  const JoinMatches({super.key, required this.match});
  @override
  State<JoinMatches> createState() {
    return _JoinMatchesState();
  }
}

class _JoinMatchesState extends State<JoinMatches> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.match.teamA.first.teamName}  vs  ${widget.match.teamB.first.teamName}',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text("Pick your favorite players"))],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => CreateTeam(match: widget.match)));
        },
        label: Text("CREATE TEAM"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
