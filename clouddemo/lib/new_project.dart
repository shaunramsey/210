import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewProject extends StatefulWidget {
  const NewProject({super.key, required this.myUid});

  final String myUid;

  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Project Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Project Description',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('projects').add({
                  'name': _nameController.text,
                  'description': _descriptionController.text,
                  'assignedUsers': [widget.myUid],
                });

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Project created successfully!'),
                    ),
                  );
                  Navigator.pop(context); // Go back to the previous screen
                }
              },
              child: const Text('Create Project'),
            ),
          ],
        ),
      ),
    );
  }
}
