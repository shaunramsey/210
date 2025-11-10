import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  const MyContainer({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green, // Color of the border
          width: 2.0, // Width of the border
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: Color.fromARGB(255, 212, 248, 212),
      ),
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }
}
