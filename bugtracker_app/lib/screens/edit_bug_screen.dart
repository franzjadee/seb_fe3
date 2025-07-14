import 'package:flutter/material.dart';
import '../database/bug_db.dart';
import '../model/bug.dart';

class EditBugScreen extends StatefulWidget {
  final Bug bug;
  const EditBugScreen({super.key, required this.bug});

  @override
  State<EditBugScreen> createState() => _EditBugScreenState();
}

class _EditBugScreenState extends State<EditBugScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _projectController;
  late TextEditingController _typeController;
  late String _severity;

  @override
  void initState() {
    super.initState();
    _projectController = TextEditingController(text: widget.bug.projectName);
    _typeController = TextEditingController(text: widget.bug.bugType);
    _severity = widget.bug.severity;
  }

  void _updateBug() async {
    if (_formKey.currentState!.validate()) {
      final updatedBug = Bug(
        id: widget.bug.id,
        projectName: _projectController.text,
        bugType: _typeController.text,
        severity: _severity,
        isResolved: widget.bug.isResolved,
      );
      await BugDatabase.instance.updateBug(updatedBug);
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
      appBar: AppBar(title: const Text('Edit Bug')),
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
                onPressed: _updateBug,
                child: const Text('Update Bug'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
