import 'package:flutter/material.dart';

//asset image steps
//https://docs.flutter.dev/ui/assets/assets-and-images
//1) create assets folder - same level as lib (not inside lib)
//2) update pubspec.yaml at the root level
//after flutter: you add this - there should be some examples there already
//flutter:
//    assets:
//        - assets/
//3) put your image assets in the /assets folder
//4) you can include them in your project using Image like:
//Image(image: AssetImage('assets/tree.jpg'));

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

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  ExampleApp({super.key});
  final _formKey = GlobalKey<FormState>();
  final _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
            body: Column(
              children: [
                Stack(
                  children: [
                    Image(image: AssetImage('assets/tree.jpg')),
                    Icon(Icons.abc),
                    Icon(Icons.stadium),
                    Text(
                      "How's it going",
                      style: TextStyle(color: Colors.green),
                    ),
                    Image(image: AssetImage("assets/tree.jpg"), width: 10),
                    ColorTweenText(text: "THIS IS MY TEXT"),
                    //https://www.washcoll.edu/_resources/assets/icons/main-logo-2.svg
                  ],
                ),
                ColorTweenText(
                  text: "Okay here",
                  startColor: Colors.green,
                  endColor: Colors.pink,
                  duration: Duration(seconds: 10),
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _ctrl,
                    validator: (value) => null,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ///hey all my form's children validated
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(_ctrl.text)));
                    }
                  },
                  child: Text("Press me"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
