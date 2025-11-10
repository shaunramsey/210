import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  const MyTitle({super.key, this.children, this.title});
  final List<Widget>? children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title ?? "-", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(
          width: 200,
          child: Divider(
            color: Colors.black, // Color of the line
            height: 10, // Total height, including padding
            thickness: 1, // Thickness of the line itself
            indent: 16, // Indent from the leading edge
            endIndent: 16, // Indent from the trailing edge
          ),
        ),
        ...?children,
      ],
    );
  }
}
