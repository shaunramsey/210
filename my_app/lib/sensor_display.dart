import 'package:flutter/material.dart';
import 'item.dart';
import 'my_divider.dart';

class SensorDisplay extends StatelessWidget {
  const SensorDisplay({super.key, required this.items});
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    List<Text> positives = [];
    List<Text> negatives = [];
    double total = 0.0;
    for (int i = 0; i < items.length; i++) {
      if (items[i].count > 0 && items[i].chargePerSecond > 0) {
        positives.add(
          Text(
            "${items[i].name}s - ${items[i].count * items[i].chargePerSecond}/s",
          ),
        );
        total += items[i].count * items[i].chargePerSecond;
      }
      if (items[i].count > 0 && items[i].chargePerSecond < 0) {
        negatives.add(
          Text(
            "${items[i].name}s - ${items[i].count * -items[i].chargePerSecond}/s",
          ),
        );
        total += items[i].count * items[i].chargePerSecond;
      }
    }

    return Column(
      children: [
        Text(
          "Overall Power: ${total.floor()}/s",
          style: TextStyle(
            fontSize: 20,
            color: total > 0
                ? Colors.blue
                : (total < 0 ? Colors.red : Colors.black),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        MyDivider(),
        Text("Chargers", style: TextStyle(fontSize: 19, color: Colors.blue)),
        MyDivider(),
        ...positives,
        SizedBox(height: 30),
        MyDivider(),
        Text("Consumers", style: TextStyle(fontSize: 19, color: Colors.red)),
        MyDivider(),
        ...negatives,
      ],
    );
  }
}
