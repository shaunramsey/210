import 'package:flutter/material.dart';

class ColorTweenText extends StatefulWidget {
  const ColorTweenText({
    required this.text,
    this.startColor = Colors.red,
    this.endColor = Colors.black,
    this.duration = const Duration(seconds: 2),
    super.key,
  });
  final String text;
  final Color startColor, endColor;
  final Duration duration;
  @override
  State<ColorTweenText> createState() => _ColorTweenTextState();
}

class _ColorTweenTextState extends State<ColorTweenText>
    with SingleTickerProviderStateMixin {
  late AnimationController ctrl;
  late Animation<Color?> _animation;

  @override
  void initState() {
    ctrl = AnimationController(
      vsync: this,
      duration: widget.duration, // Animation duration
    )..repeat(reverse: true); // Repeats the animation in reverse

    _animation = ColorTween(
      begin: widget.startColor, // Starting color
      end: widget.endColor, // Ending color
    ).animate(ctrl);

    _animation.addListener(() {
      setState(() {}); // Rebuilds the widget with the new color
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.text, style: TextStyle(color: _animation.value));
  }
}
