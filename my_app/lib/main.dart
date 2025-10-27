import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* STEPS FOR Shared_Preferences
1.) add the package from pub.dev to your pubspec.yaml. You can edit pubspec.yaml directly or use:
flutter pub add shared_preferences
2) import the package so you can use its features
import 'package:shared_preferences/shared_preferences.dart';
3) use the features
- setup _prefs as a late var that is initialized in initState
- use setInt and getInt functions to set and get integers in _prefs (other types available or through string)
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late SharedPreferences _prefs;

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await _prefs.setInt('counter', _counter);
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = _prefs.getInt('counter') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 100),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add_alert),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _counter = 0;
              });
            },
            tooltip: 'Reset',
            child: const Icon(Icons.restore),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
