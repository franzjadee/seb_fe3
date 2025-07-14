import 'package:flutter/material.dart';
import '../database/bug_db.dart';
import '../model/bug.dart';

class ResolvedBugsScreen extends StatelessWidget {
  const ResolvedBugsScreen({super.key});

  Future<List<Bug>> _getResolvedBugs() async {
    final allBugs = await BugDatabase.instance.getBugs();
    return allBugs.where((bug) => bug.isResolved).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resolved Bugs')),
      body: FutureBuilder<List<Bug>>(
        future: _getResolvedBugs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No resolved bugs'));
          } else {
            final bugs = snapshot.data!;
            return ListView.builder(
              itemCount: bugs.length,
              itemBuilder: (context, index) {
                final bug = bugs[index];
                return ListTile(
                  title: Text('${bug.projectName} (${bug.severity})'),
                  subtitle: Text('Type: ${bug.bugType}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}