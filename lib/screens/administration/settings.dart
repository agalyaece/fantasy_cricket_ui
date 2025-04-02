import 'package:fc_ui/data/settings_item.dart';
import 'package:fc_ui/models/settings_category.dart';
import 'package:fc_ui/screens/administration/players.dart';
import 'package:fc_ui/screens/administration/teams.dart';
import 'package:fc_ui/screens/administration/tournament.dart';
import 'package:fc_ui/widgets/administration/grid_item.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  void _selectCategory(BuildContext context, SettingsCategory category) {
    if (category.id == "c3") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => PlayersScreen()));
    }
    if (category.id == "c2") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => TeamsScreen()));
    }
    if (category.id == "c1") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => TournamentScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,

      appBar: AppBar(title: Text("Administration")),
      body: Center(
        child: GridView(
          padding: const EdgeInsets.all(24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3/2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          children: [
            for (final category in availableCategories)
              GridItem(
                category: category,
                onSelectCategory: () {
                  _selectCategory(context, category);
                },
              ),
          ],
        ),
      ),
    );
  }
}
