import 'package:flutter/material.dart';
import 'package:newapp/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
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
  bool _isLoading = false;
  String? _errorMessage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _login({bool register = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error message
    });
    try {
      if (register) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
    } catch (e) {
      debugPrint('Error during ${register ? 'registration' : 'login'}: $e');
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
      // Handle errors here
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            MyHomeCard(),

            StreamBuilder<User?>(
              // Listen to Firebase auth state changes dynamically
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // If Firebase is still checking the login status, show a loading spinner
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: _errorMessage,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            errorText:
                                _errorMessage, // Display error message if any
                          ),

                          obscureText: true,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: Text('Login | $_isLoading'),
                      ),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _login(register: true),
                        child: Text('Register | $_isLoading'),
                      ),
                      Center(child: Text('No user is currently logged in.')),
                    ],
                  );
                }
                return Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _logout,
                        child: const Text('Logout'),
                      ),
                      Text(
                        "Authenticated user: ${snapshot.data?.email ?? 'None'}",
                      ),
                    ],
                  ),
                );
              },
            ),
            Text(_errorMessage ?? '', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
