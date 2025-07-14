import 'package:flutter/material.dart';
import '../database/bug_db.dart';
import '../model/bug.dart';
import 'add_bug_screen.dart';
import 'edit_bug_screen.dart';
import 'resolved_bugs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Bug> _bugs = [];

  @override
  void initState() {
    super.initState();
    _refreshBugList();
  }

  void _refreshBugList() async {
    final bugs = await BugDatabase.instance.getBugs();
    setState(() {
      _bugs = bugs.where((bug) => !bug.isResolved).toList(); // Show only unresolved
    });
  }

  void _toggleResolved(Bug bug) async {
    final updated = Bug(
      id: bug.id,
      projectName: bug.projectName,
      bugType: bug.bugType,
      severity: bug.severity,
      isResolved: true,
    );
    await BugDatabase.instance.updateBug(updated);
    _refreshBugList();
  }

  void _confirmResolve(Bug bug) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Resolved'),
        content: const Text('Are you sure you want to mark this bug as resolved?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Mark as Resolved'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _toggleResolved(bug);
    }
  }

  void _deleteBug(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this bug?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await BugDatabase.instance.deleteBug(id);
      _refreshBugList();
    }
  }

  void _editBug(Bug bug) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBugScreen(bug: bug),
      ),
    );
    _refreshBugList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 54, 54),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 105, 105, 105),
        foregroundColor: Colors.black,  
        elevation: 1,
        title: const Text('Bug Tracker', style: TextStyle(color: Color.fromARGB(255, 255, 253, 253))),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Resolved Bugs',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResolvedBugsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          itemCount: _bugs.length,
          itemBuilder: (context, index) {
            final bug = _bugs[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  bug.projectName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: ${bug.bugType}'),
                    Text('Severity: ${bug.severity}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 0, 0)),
                      onPressed: () => _editBug(bug),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Color.fromARGB(255, 0, 0, 0)),
                      onPressed: () => _confirmResolve(bug),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
                      onPressed: () => _deleteBug(bug.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBugScreen()),
          );
          _refreshBugList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
