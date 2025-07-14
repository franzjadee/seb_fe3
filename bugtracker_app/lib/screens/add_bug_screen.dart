import 'package:flutter/material.dart';
import '../database/bug_db.dart';
import '../model/bug.dart';

class AddBugScreen extends StatefulWidget {
  const AddBugScreen({super.key});

  @override
  State<AddBugScreen> createState() => _AddBugScreenState();
}

class _AddBugScreenState extends State<AddBugScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectController = TextEditingController();
  final _typeController = TextEditingController();
  String _severity = 'Low';

  void _saveBug() async {
    if (_formKey.currentState!.validate()) {
      final newBug = Bug(
        projectName: _projectController.text,
        bugType: _typeController.text,
        severity: _severity,
      );
      await BugDatabase.instance.addBug(newBug);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _projectController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report New Bug')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _projectController,
                decoration: const InputDecoration(labelText: 'Project Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Bug Type'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _severity,
                items: ['Low', 'Medium', 'High'].map((level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (value) => setState(() => _severity = value!),
                decoration: const InputDecoration(labelText: 'Severity'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBug,
                child: const Text('Save Bug'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}