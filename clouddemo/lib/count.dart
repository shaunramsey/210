import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudCount extends StatefulWidget {
  const CloudCount({super.key, required this.email, required this.uid});
  final String email;
  final String uid;

  @override
  State<CloudCount> createState() => _CloudCountState();
}

class _CloudCountState extends State<CloudCount> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: _logout, child: const Text('Logout')),
        Text("Authenticated user: ${widget.email}"),
      ],
    );
  }
}
