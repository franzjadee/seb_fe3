import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/resolved_bugs_screen.dart';

void main() {
  runApp(const BugTrackerApp());
}

class BugTrackerApp extends StatelessWidget {
  const BugTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bug Tracker',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const HomeScreen(),
    );
  }
}