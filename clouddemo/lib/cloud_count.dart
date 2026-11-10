import 'package:flutter/material.dart';

class CloudCount extends StatelessWidget {
  const new({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Text("Count = $count");
  }
}
