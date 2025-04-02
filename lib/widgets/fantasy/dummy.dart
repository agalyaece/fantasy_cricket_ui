// import 'package:flutter/material.dart';

// class CreateTeam extends StatefulWidget {
//   const CreateTeam({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _CreateTeamState();
//   }
// }

// class _CreateTeamState extends State<CreateTeam> {
//   List<Map<String, dynamic>> selectedPlayers = [];
//   int totalCredits = 100;
//   int usedCredits = 0;
//   String captain = '';
//   String viceCaptain = '';

//   List<Map<String, dynamic>> players = [
//     {
//       'name': 'Player 1',
//       'role': 'Wicket-Keeper',
//       'team': 'Team A',
//       'credits': 9,
//     },
//     {
//       'name': 'Player 2',
//       'role': 'Batsman',
//       'team': 'Team B',
//       'credits': 8,
//     },
//     {
//       'name': 'Player 3',
//       'role': 'All-rounder',
//       'team': 'Team A',
//       'credits': 10,
//     },
//     {
//       'name': 'Player 4',
//       'role': 'Bowler',
//       'team': 'Team B',
//       'credits': 7,
//     },
//     {
//       'name': 'Player 5',
//       'role': 'Wicket-Keeper',
//       'team': 'Team A',
//       'credits': 6,
//     },
//     {
//       'name': 'Player 6',
//       'role': 'Batsman',
//       'team': 'Team B',
//       'credits': 8,
//     },
//     {
//       'name': 'Player 7',
//       'role': 'All-rounder',
//       'team': 'Team A',
//       'credits': 9,
//     },
//     {
//       'name': 'Player 8',
//       'role': 'Bowler',
//       'team': 'Team B',
//       'credits': 7,
//     },
//     {
//       'name': 'Player 9',
//       'role': 'Batsman',
//       'team': 'Team A',
//       'credits': 8,
//     },
//     {
//       'name': 'Player 10',
//       'role': 'Bowler',
//       'team': 'Team B',
//       'credits': 6,
//     },
//     {
//       'name': 'Player 11',
//       'role': 'Wicket-Keeper',
//       'team': 'Team A',
//       'credits': 5,
//     },
//     {
//       'name': 'Player 12',
//       'role': 'Batsman',
//       'team': 'Team B',
//       'credits': 9,
//     },
//     {
//       'name': 'Player 13',
//       'role': 'All-rounder',
//       'team': 'Team A',
//       'credits': 8,
//     },
//     {
//       'name': 'Player 14',
//       'role': 'Bowler',
//       'team': 'Team B',
//       'credits': 10,
//     }
//   ];

//   void addPlayer(Map<String, dynamic> player) {
//     if (selectedPlayers.length < 11 &&
//         usedCredits + player['credits'] <= totalCredits &&
//         !selectedPlayers.contains(player)) {
//       setState(() {
//         selectedPlayers.add(player);
//         usedCredits += player['credits'];
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Cannot add more players or insufficient credits.')),
//       );
//     }
//   }

//   void removePlayer(Map<String, dynamic> player) {
//     setState(() {
//       selectedPlayers.remove(player);
//       usedCredits -= player['credits'];
//       if(captain == player['name']){
//         captain = "";
//       }
//       if(viceCaptain == player['name']){
//         viceCaptain = "";
//       }
//     });
//   }

//   void setCaptain(String playerName) {
//     setState(() {
//       captain = playerName;
//     });
//   }

//   void setViceCaptain(String playerName) {
//     setState(() {
//       viceCaptain = playerName;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Team'),
//         backgroundColor: Colors.green,
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8.0),
//             color: Colors.grey[200],
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Players Selected',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text('{selectedPlayers.length}/11', style: const TextStyle(color: Colors.grey)),
// ],
// ),
// ElevatedButton(
// onPressed: () {
// showDialog(context: context, builder: (context) => previewTeamDialog());
// },
// child: const Text('Preview Team'),
// ),
// ],
// ),
// ),
// Expanded(
// <0>child: ListView.builder(
// scrollDirection: Axis.vertical,
// itemCount: players.length,
// itemBuilder: (context, index) {
// final player = players[index];
// return</0> Card(
// child: ListTile(
// title: Text(player['name']),
// subtitle: Text('{player['role']} (${player['team']}) -  {player['credits']} Credits'),
// trailing: ElevatedButton(
// onPressed: () {
// addPlayer(player);
// },
// child: const Text('Add'),
// ),
// ),
// );
// },
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: ElevatedButton(
// onPressed: () {
// if (selectedPlayers.length == 11) {
// showDialog(context: context, builder: (context) => finalizeTeamDialog());
// } else {
// ScaffoldMessenger.of(context).showSnackBar(
// const SnackBar(content: Text('Select 11 players to finalize team.')),
// );
// }
// },
// style: ElevatedButton.styleFrom(
// minimumSize: const Size(double.infinity, 50),
// ),
// child: const Text('Finalize Team'),
// ),
// ),
// ],
// ),
// );
// }
// Widget previewTeamDialog() {
// return AlertDialog(
// title: const Text('Preview Team'),
// content: SingleChildScrollView(
// child: Column(
// children: selectedPlayers.map((player) => ListTile(
// title: Text(player['name']),
// subtitle: Text('{player['role']} (${player['team']}) -  {player['credits']} Credits'),
// trailing: IconButton(
// icon: const Icon(Icons.remove_circle),
// onPressed: () {
// removePlayer(player);
// Navigator.pop(context);
// showDialog(context: context, builder: (context) => previewTeamDialog());
// },
// ),
// )).toList(),
// ),
// ),
// actions: <Widget>[
// TextButton(
// onPressed: () => Navigator.pop(context),
// child: const Text('Close'),
// ),
// ],
// );
// }
// Widget finalizeTeamDialog() {
// return AlertDialog(
// title: const Text('Select Captain and Vice-Captain'),
// content: SingleChildScrollView(
// child: Column(
// children: selectedPlayers.map((player) => ListTile(
// title: Text(player['name']),
// subtitle: Text('{player['role']} (${player['team']})'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => setCaptain(player['name']),
//                   child: Text(captain == player['name'] ? 'Captain' : 'Set C'),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () => setViceCaptain(player['name']),
//                   child: Text(viceCaptain == player['name'] ? 'VC' : 'Set VC'),
//                 ),
//               ],
//             ),
//           )).toList(),
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             if (captain.isNotEmpty && viceCaptain.isNotEmpty) {
//               Navigator.pop(context);
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('