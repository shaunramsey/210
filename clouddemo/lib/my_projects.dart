import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clouddemo/project.dart';

class MyProjects extends StatelessWidget {
  const MyProjects({super.key, required this.projects, required this.myUid});
  final List<Project> projects;
  final String myUid;

  @override
  Widget build(BuildContext context) {
    debugPrint("Building MyProjects with ${projects.length} projects");
    return Column(
      children: [
        ...projects
            .map(
              (project) => ListTile(
                key: ValueKey(project.uid),
                title: Text(project.name),
                subtitle: Text(project.description),
                trailing: IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('projects')
                        .doc(project.uid) // The specific project document ID
                        .update({
                          'assignedUsers': FieldValue.arrayRemove([
                            myUid,
                          ]), // 👈 Atomic removal
                        });

                    // If you'd like, you could delete the whole project
                    // FirebaseFirestore.instance
                    //     .collection('projects')
                    //     .doc(project.uid)
                    //     .delete()
                    //     //     .then((_) {
                    //     //   debugPrint('Project ${project.name} deleted successfully.');
                    //     // })
                    //     .catchError((error) {
                    //       debugPrint(
                    //         'Error deleting project ${project.name}: $error',
                    //       );
                    //     });
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
