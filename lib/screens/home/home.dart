import 'package:fc_ui/screens/administration/settings.dart';
import 'package:fc_ui/screens/fantasy/fantasy_home.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fantasy Cricket'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => SettingsScreen()));
            },
            icon: Icon(Icons.settings_sharp),
          ),
        ],
      ),
      body: FantasyHomeScreen(),
    );
  }
}
