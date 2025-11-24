import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      child: Divider(
        color: Colors.black, // Color of the line
        height: 10, // Total height, including padding
        thickness: 1, // Thickness of the line itself
        indent: 16, // Indent from the leading edge
        endIndent: 16, // Indent from the trailing edge
      ),
    );
  }
}
