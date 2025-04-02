import 'package:fc_ui/screens/home/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 18, 3, 114),
  surface: Colors.white,
  //  const Color.fromARGB(255, 49, 50, 66)
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  primaryColor: colorScheme.primary,
  colorScheme: colorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.onPrimaryContainer,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fantasy Cricket',
      theme: theme,
      home: const SplashScreen(),
    );
  }
}
