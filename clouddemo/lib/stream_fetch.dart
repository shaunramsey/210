import 'package:clouddemo/cloud_count.dart';
import 'package:clouddemo/my_projects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clouddemo/project.dart';
import 'package:clouddemo/new_project.dart';

/*** set up firebase firestore first ***/
// go to firebase console and open the project you made for auth!
// go to databases, firestore - create the database
// firebase has a variety of dbs ... firestore is the one you want
//options during the create: standard edition, default location/id, Start in test mode (we'll need to modify these later), no backups

/*** get the pub dev pieces we need ***/
// grab cloud_firestore from pub_dev and put it in your pubspec yaml

/*** fetching data from Firestore ***/
// you'll do this via streams I've given an example below of a collection and a doc

/*** changing data in firestore ****/
// you can "add" a doc, "update", "set", or "delete"
// atomic operations allow you to do things without having to READ and update based on what you read
// add and set are going to work on dictionaries where set will overwrite

//your project will start with an "end date" for access to the db
// you can add rules to restrict access and you should do so. Here's what I used for this project

/******
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // 1. Secure users/{uid} so only the matching authenticated user has access
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }

    // 2. Secure projects/{projectId} based on the assignedUsers field
    match /projects/{projectId} {
      
      // Allow read, update, and delete if the user's UID is in the project's assignedUsers array
      allow read, update, delete: if request.auth != null 
                                  && request.auth.uid in resource.data.assignedUsers;
      
      // Allow creating a project only if the creator includes their own UID in assignedUsers
      allow create: if request.auth != null 
                    && request.auth.uid in request.resource.data.assignedUsers;
    }
    
  }
}
*****/

class StreamFetch extends StatefulWidget {
  const StreamFetch({super.key, required this.email, required this.uid});
  final String email;
  final String uid;

  @override
  State<StreamFetch> createState() => _CloudCountState();
}

class _CloudCountState extends State<StreamFetch> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  late int count = 0;
  void _increment() async {
    try {
      await FirebaseFirestore.instance.doc("users/${widget.uid}").set(
        {
          'count': FieldValue.increment(
            1,
          ), //increments count by 1 if it existed
        },
        SetOptions(merge: true),
      ); //need setoptions in case doc doesn't exist yet
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Count updated successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }

    //We could do this with a direct set, but this is bette really
    // FirebaseFirestore.instance.collection("users").doc(widget.uid).set({
    //   "count": count + 1,
    // });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .doc("users/${widget.uid}")
                  .snapshots(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasData &&
                    asyncSnapshot.data?.exists == true) {
                  return CloudCount(count: asyncSnapshot.data?['count'] ?? 0);
                }
                return CloudCount(count: 0);
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("projects")
                  .where('assignedUsers', arrayContains: widget.uid)
                  .snapshots(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
                  return MyProjects(
                    projects: asyncSnapshot.data!.docs
                        .map(
                          (doc) => Project(
                            uid: doc.id,
                            name: doc['name'] ?? 'No Name',
                            description: doc['description'] ?? 'No Description',
                          ),
                        )
                        .toList(),
                    myUid: widget.uid,
                  );
                }
                return const Text("Last updated: N/A");
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewProject(myUid: widget.uid),
                  ),
                );
              },
              child: const Text('Create New Project'),
            ),
            ElevatedButton(onPressed: _increment, child: Icon(Icons.plus_one)),
            SizedBox(height: 350),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout (${widget.email})'),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
