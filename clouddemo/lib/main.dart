import 'package:clouddemo/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

/*

************** INSTALL FIREBASE PACKAGES INTO YOUR APPLICATION**************
- Go to pub dev
- Search for firebase_auth and firebase_core
- Click the "copy" next to firebase_auth 7.0.1 and 
- Go to pubspec.yaml
- Paste it under dependencies on the same tab same level as flutter
- Click the "copy" next to firebase_core 5.1.0
- Go to pubspec.yaml
- Paste it under dependencies on the same tab same level as flutter

********** CREATE A NEW FIREBASE PROJECT **********
 - goto console.firebase.google.com
 - Create a new firebase project
 - Give it a name
 - I don't enable gemini in firebase - so I toggle this off
 - Hit Continue
 - I leave analytics on - it's useful for tracking usage and performance
 - Hit Continue
 - Select default account for firebase
 - Hit Create Project
 - Wait and then Hit Continue
 - Hit the Search Button in the Upper Left
 - Select Security -> Authentication
 - Click Get Started
 - Choose Email/Password
 - Click Enable for Email/Password
 - Click Save

******* GET YOUR FIREBASE CONFIG OBJECT ********
 - go to Project Settings (Gear icon)
 - Scroll down to your apps
 - select web app
 - Give it a name
 - Click Register app (you may add hosting if you need it or add it later)
 - Copy the firebaseConfig object
 - Go to lib/main.dart
 - Paste the firebaseConfig object in the main.dart file above main (or whichever place you'll initialize your firebase)
 - Note: It will tell you to get the CLI but it can add many steps that you may not use. I do use it, but for this demo we're doing things manually

**********ADD THE EMAIL AND PASSWORD WIDGETS***************
 - Go to the widget that will hold your auth
 - add final _emailController = TextEditingController();
 - add final _passwordController = TextEditingController();
 - Go to where you want the widgets to exist and add the formfields for email and password - obscure pwrd


  ******* add the button to do the login or register ********
  - add new state bool _isLoading = false; -- this is not strictly necessary but can prevent double taps
  - add async functions for login, register and logout - see _login, and _logout
  - add widget buttons for login, register, and logout

  **** set up main ***
  - make it async, ensure widgets are initialized and initialize firebase with the config object
  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseConfig.isNotEmpty
        ? FirebaseOptions(
            apiKey: firebaseConfig['apiKey']!,
            authDomain: firebaseConfig['authDomain']!,
            projectId: firebaseConfig['projectId']!,
            storageBucket: firebaseConfig['storageBucket']!,
            messagingSenderId: firebaseConfig['messagingSenderId']!,
            appId: firebaseConfig['appId']!,
            measurementId: firebaseConfig['measurementId']!,
          )
        : null,
  );


  *** add a streambuilder to listen to user changes ***
    - based on the stream, show the login/register or logout/info

  *** set up error display messages ***
  - formfields input decorator do have an errormessage property that can be used to display errors


*/

const Map<String, String> firebaseConfig = {
  "apiKey": "AIzaSyA2tft1tG-Atrb834juV0PVUlJFmQuGTeg",
  "authDomain": "authenticationdemostration.firebaseapp.com",
  "projectId": "authenticationdemostration",
  "storageBucket": "authenticationdemostration.firebasestorage.app",
  "messagingSenderId": "1021736793005",
  "appId": "1:1021736793005:web:f0860ec8c095613880a724",
  "measurementId": "G-H71LGKZ3MR",
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseConfig.isNotEmpty
        ? FirebaseOptions(
            apiKey: firebaseConfig['apiKey']!,
            authDomain: firebaseConfig['authDomain']!,
            projectId: firebaseConfig['projectId']!,
            storageBucket: firebaseConfig['storageBucket']!,
            messagingSenderId: firebaseConfig['messagingSenderId']!,
            appId: firebaseConfig['appId']!,
            measurementId: firebaseConfig['measurementId']!,
          )
        : null,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Cloud Demo'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: MyAuthWidget(),
      //Text(_errorMessage ?? '', style: TextStyle(color: Colors.red)),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
