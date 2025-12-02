import 'package:flutter/material.dart';

class MyResource extends StatelessWidget {
  const MyResource({super.key, required this.title, required this.resource});
  final String title, resource;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: 152,
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("$title:"),
            ),
          ),
          SizedBox(width: 5),
          SizedBox(child: Text(resource)),
        ],
      ),
    );
  }
}
