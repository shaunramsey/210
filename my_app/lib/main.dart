import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
//import 'package:shared_preferences/shared_preferences.dart';
import 'my_container.dart';
import 'my_title.dart';
import 'my_resource.dart';
import 'item.dart';
import 'sensor_display.dart'; //SensorDisplay

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// firebase build web --release
// firebase deply --only hosting
// now you can go visit your website from the hosting URL

//goto firebase console for your project
//goto build - firebase database (firestore) --- not realtime database
//choose to build, any server, "test mode" - which gives accesss until a certain date -- you'll have to update your security rules or move the date if you continue to use the app
//flutter pub add cloud_firestore in console then flutter run

enum Resource { WATER, HYDROGEN, OXYGEN, NITROGEN, ARGON }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Chemistry Set',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MyHomePage(title: 'The Chemistry Set'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<int> _events = [0, 0, 0, 0];
  final List<Item> _items = [
    Item("Bucket", 0, 0, 1, -1, 1),
    Item("Electrolyzer", 0, 0, 20, -1, 1),
    Item("Solar Panel", 1, 1, 100, -1, 1000000),
    Item("Pump", -0.9, 0, 100, 0, 1000000),
    Item("Battery", 0, 10, 50, -1, 1000000),
    Item("Sensor", -0.1, 0, 50, -1, 1),
    Item("Atmo. Collector", -3.4, 0, 200, 2, 1),
  ];
  //h2o, h2, o2, n2, ar
  final List<int> _resources = [0, 0, 0, 0, 0];

  int _quanta = 1;
  int _energy = 0;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final List<int> _resourcePrices = [0, 0, 0, 0, 0];
  final List<String> _resourceNames = [
    "Water",
    "Hydrogen",
    "Oxygen",
    "Nitrogen",
    "Argon",
  ];
  final Random _rng = Random();
  //Timer? _timer;
  //late SharedPreferences _prefs;
  late TabController _tabController;
  String _latestMessage = "";
  String _errorMessage = "";

  String dropdownValue = "Default";
  List<String> dropdownList = <String>['Default', 'One', 'Two', 'Three'];
  bool _saveWasLoaded = false;

  void loadSave() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? 'NA';
    debugPrint("Loading save file for  users/$uid/saves/$dropdownValue");
    if (uid == 'NA') return; // don't save if nobody is there to save

    String path = "users/$uid/saves/$dropdownValue";
    DocumentSnapshot documentSnapshot = await db.doc(path).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      debugPrint('Document data: ${documentSnapshot.data()}');
      if (data == null) return;
      _resources[Resource.WATER.index] = data['h2o'] ?? 0;
      _resources[Resource.OXYGEN.index] = data['o2'] ?? 0;
      _resources[Resource.HYDROGEN.index] = data['h2'] ?? 0;
      _resources[Resource.NITROGEN.index] = data['n2'] ?? 0;
      _resources[Resource.ARGON.index] = data['ar'] ?? 0;
      _quanta = data['quanta'] ?? 1;
      _energy = data['energy'] ?? 0;
      for (int i = 0; i < _items.length; i++) {
        _items[i].count = data['item$i'] ?? 0;
      }
      _saveWasLoaded = true;
    } else {
      Map<String, dynamic> defaultSave = {
        "quanta": 1,
      }; // everything else is empty and will be 0
      db.doc(path).set(defaultSave);
      for (int i = 0; i < _items.length; i++) {
        _items[i].count = 0;
      }
      for (int i = 0; i < _resources.length; i++) {
        _resources[i] = 0;
      }
      _quanta = 1;
      _energy = 0;
      _saveWasLoaded = true;
      print('Document does not exist - setting up default values');
    }
  }

  void setPrefs() async {
    //let's not save if we haven't loaded from save before
    String uid = FirebaseAuth.instance.currentUser?.uid ?? 'NA';
    debugPrint("Storing save file for  users/$uid/saves/$dropdownValue");

    if (!_saveWasLoaded) return;
    if (uid == 'NA') return; // don't save if nobody is there to save

    String path = "users/$uid/saves/$dropdownValue";
    Map<String, dynamic> save = {};
    save['h2o'] = _resources[Resource.WATER.index];
    save['o2'] = _resources[Resource.OXYGEN.index];
    save['h2'] = _resources[Resource.HYDROGEN.index];
    save['n2'] = _resources[Resource.NITROGEN.index];
    save['ar'] = _resources[Resource.ARGON.index];
    save['energy'] = _energy;
    save['quanta'] = _quanta;
    for (int i = 0; i < _items.length; i++) {
      save['item$i'] = _items[i].count;
    }
    debugPrint("Executing the save");
    db.doc(path).set(save);

    //note to self - MAKE SURE TO ADD THE OTHER ITEMS INTO SHARD PREFERENCES
    // _prefs.setInt('h2o', _h2o);
    // _prefs.setInt('o2', _o2);
    // _prefs.setInt('h2', _h2);
    // _prefs.setInt('energy', _energy);
    // _prefs.setInt('quanta', _quanta);
    // for (int i = 0; i < _items.length; i++) {
    //   _prefs.setInt('items$i', _items[i].count);
    // }
  }

  void gatherWater() async {
    setState(() {
      _resources[Resource.WATER.index]++;
    });
  }

  void electrolyzeWater() async {
    setState(() {
      _resources[Resource.WATER.index] -= 2;
      _resources[Resource.HYDROGEN.index] += 2;
      _resources[Resource.OXYGEN.index] += 1;
      if (_resources[Resource.OXYGEN.index] > 50 && _events[0] == 0) {
        _tabController.animateTo(2);
        _events[0]++;
        _latestMessage =
            "A stranger is here, begging for oxygen. \n Take what is offered and give 20 oxygen \nOR\n wait for the inevitable and take what is left.";
      }
    });
  }

  void _marketTimer() {
    //_timer =
    Timer.periodic(Duration(seconds: 3), (timer) {
      _resourcePrices[0] = _rng.nextInt(2) + 1;
      _resourcePrices[1] = 1;
      _resourcePrices[2] = _rng.nextInt(3) + 1;
      _resourcePrices[3] = 0;
      setState(() {});
    });
  }

  int _getMaxEnergy() {
    int sum = 0;
    for (int i = 0; i < _items.length; i++) {
      sum += _items[i].chargeReserve * _items[i].count;
    }
    //debugPrint("_getMaxEnergy $sum");
    return sum;
  }

  void _energyTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      double negativeDelta = 0;
      double positiveDelta = 0;
      for (int i = 0; i < _items.length; i++) {
        if (_items[i].chargePerSecond > 0) {
          positiveDelta += _items[i].count * _items[i].chargePerSecond;
        } else {
          negativeDelta += _items[i].count * _items[i].chargePerSecond;
          //add up solar panels and drains and the like
        }
      }
      //debugPrint("b4 $_energy $positiveDelta $negativeDelta");
      int startEnergy = _energy;
      _energy += (positiveDelta + negativeDelta).floor();
      //debugPrint("af $_energy");
      if (_energy > _getMaxEnergy()) {
        _energy = _getMaxEnergy();
      }
      if (_energy < 0) {
        _energy = 0;
      }

      if (_energy > 0) {
        //then we have energy to do stuff
        for (int i = 0; i < _items.length; i++) {
          List<int> rg = _items[i].generateResources();
          _resources[Resource.WATER.index] += rg[0] * _items[i].count;
          _resources[Resource.HYDROGEN.index] += rg[1] * _items[i].count;
          _resources[Resource.OXYGEN.index] += rg[2] * _items[i].count;
        }
      } else {
        // debugPrint("0 < $_energy ${positiveDelta.floor()}");
        _energy = startEnergy + positiveDelta.floor();
      }

      setState(() {});
    });
  }

  void _saveTimer() {
    Timer.periodic(Duration(seconds: 60), (timer) async {
      setPrefs();
    });
  }

  Future<void> _initSaving() async {
    // _prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _h2o = _prefs.getInt('h2o') ?? 0;
    //   _o2 = _prefs.getInt('o2') ?? 0;
    //   _h2 = _prefs.getInt('h2') ?? 0;
    //   _quanta = _prefs.getInt('quanta') ?? 1;
    //   _energy = _prefs.getInt('energy') ?? 0;
    //   for (int i = 0; i < _items.length; i++) {
    //     _items[i].count = _prefs.getInt('items$i') ?? 0;
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initSaving();
    _marketTimer();
    _energyTimer();
    _saveTimer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> itemList = [];
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].count > 0) {
        String count = _items[i].count > 1 ? "- ${_items[i].count}" : "";
        itemList.add(Text("${_items[i].name} $count"));
      }
    }
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 100),
                      SizedBox(width: 100, child: Text("Email:")),
                      SizedBox(
                        width: 200,
                        child: TextField(controller: _emailController),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 100),
                      SizedBox(width: 100, child: Text("Password:")),
                      SizedBox(
                        width: 200,
                        child: TextField(controller: _passwordController),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          _errorMessage = "$e";
                        });
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        loadSave();
                      } catch (e) {
                        setState(() {
                          _errorMessage = "$e";
                        });
                      }
                    },
                    child: Text("Sign In"),
                  ),
                  SizedBox(height: 20),
                  Text("  - OR -"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          _errorMessage = "$e";
                        });
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                        loadSave();
                      } catch (e) {
                        setState(() {
                          _errorMessage = "$e";
                        });
                      }
                    },
                    child: Text("Sign Up"),
                  ),
                  SizedBox(height: 20),
                  _errorMessage == ""
                      ? SizedBox()
                      : Container(
                          padding: const EdgeInsets.all(
                            16.0,
                          ), // Add padding around the text
                          decoration: BoxDecoration(
                            color: Colors.red, // Set the background color
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ), // Optional: Add rounded corners
                          ),

                          child: Text(
                            _errorMessage,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        }
        String userEmail = snapshot.data!.email ?? "?";
        if (!_saveWasLoaded) {
          _saveWasLoaded = true;
          debugPrint("got here");
          loadSave();
        }
        //String userID = snapshot.data!.
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.green),
                    child: Column(
                      children: [
                        Text('The Chemistry Set'),
                        Text(userEmail),
                        Text(
                          "uid: ${FirebaseAuth.instance.currentUser?.uid ?? 'N/A'}",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.save_as),
                    title: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.green,
                        highlightColor: Colors.green,
                        hoverColor: Colors.green,
                        canvasColor: Colors.green[100],
                        focusColor: Colors.white,
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 82, 3),
                        ),
                        underline: Container(height: 2, color: Colors.green),
                        onChanged: (String? value) {
                          Navigator.pop(context); // pop off the drawer
                          setState(() {
                            //this will force a loadsave
                            _saveWasLoaded = false;
                            dropdownValue = value!;
                          });
                        },
                        items: dropdownList.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    tileColor: Colors.white,
                    onTap: null,
                  ),
                  ListTile(
                    title: const Text('Reset Progress'),
                    tileColor: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Are You Sure?'),
                            content: const Text(
                              'This will reset your progress. Are You Sure?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  _quanta = 1;
                                  for (int i = 0; i < _items.length; i++) {
                                    _items[i].count = 0;
                                  }
                                  for (int i = 0; i < _resources.length; i++) {
                                    _resources[i] = 0;
                                  }
                                  setState(() {});
                                  Navigator.of(
                                    context,
                                  ).pop(); // Close the dialog
                                },
                                child: const Text('OK'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Close the dialog
                                },
                                child: const Text('NO'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Cheat Resources'),
                    tileColor: Colors.orange,
                    onTap: () {
                      for (int i = 0; i < _resources.length; i++) {
                        _resources[i] += 100;
                      }
                      _quanta += 1000;
                      setState(() {});
                    },
                  ),
                  ListTile(
                    title: const Text('Cheat Progress'),
                    tileColor: Colors.orange,
                    onTap: () {
                      for (int i = 0; i < _resources.length; i++) {
                        _resources[i] += 1000;
                      }
                      _quanta = 1000;
                      for (int i = 0; i < _items.length; i++) {
                        _items[i].count = 10;
                      }
                      setState(() {});
                    },
                  ),
                  ListTile(
                    title: const Text("Sign Out"),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.blue[300],
                  indicatorColor: Colors.green[900],
                  tabs: [
                    Tab(icon: Icon(Icons.shop)),
                    Tab(icon: Icon(Icons.inventory)),
                    Tab(icon: Icon(Icons.message)),
                  ],
                ),
                _items[2].count > 0
                    ? Container(
                        color: Colors.yellow,
                        child: Row(
                          children: [
                            MyResource(
                              title: "Energy",
                              resource: "$_energy / ${_getMaxEnergy()}",
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      //1st tab
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //the shop
                            MyContainer(
                              // the shop
                              child: MyTitle(
                                title: "The Shop",
                                children: <Widget>[
                                  MyResource(
                                    title: "Quanta",
                                    resource: "$_quanta",
                                  ),
                                  SizedBox(height: 10),
                                  for (
                                    int index = 0;
                                    index < _items.length;
                                    index++
                                  )
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed:
                                            _items[index].count >=
                                                    _items[index].stackLimit ||
                                                _quanta < _items[index].cost
                                            ? null
                                            : () {
                                                setState(() {
                                                  _items[index].count++;
                                                  _quanta -= _items[index].cost;
                                                });
                                              },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(250, 30),
                                        ),
                                        child: Text(
                                          _items[index].count >=
                                                  _items[index].stackLimit
                                              ? "${_items[index].name} - ${_items[index].count} Owned"
                                              : "Buy ${_items[index].name} [${_items[index].count}]: ${_items[index].cost}",
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            //the market
                            MyContainer(
                              child: MyTitle(
                                title: "The Market",
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        _resources[Resource.WATER.index] > 0
                                        ? () {
                                            _resources[Resource.WATER.index]--;
                                            _quanta += _resourcePrices[0];
                                            setState(() {});
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(200, 30),
                                    ),
                                    child: MyResource(
                                      title:
                                          "${_resourceNames[0]} (${_resources[Resource.WATER.index]})",
                                      resource: "${_resourcePrices[0]}q",
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed:
                                        _resources[Resource.HYDROGEN.index] > 0
                                        ? () {
                                            _resources[Resource
                                                .HYDROGEN
                                                .index]--;
                                            _quanta += _resourcePrices[1];
                                            setState(() {});
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(200, 30),
                                    ),
                                    child: MyResource(
                                      title:
                                          "${_resourceNames[1]} (${_resources[Resource.HYDROGEN.index]})",
                                      resource: "${_resourcePrices[1]}q",
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed:
                                        _resources[Resource.OXYGEN.index] > 0
                                        ? () {
                                            _resources[Resource.OXYGEN.index]--;
                                            _quanta += _resourcePrices[2];
                                            setState(() {});
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(200, 30),
                                    ),
                                    child: MyResource(
                                      title:
                                          "${_resourceNames[2]} (${_resources[Resource.OXYGEN.index]})",
                                      resource: "${_resourcePrices[2]}q",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //2nd tab - gathering resources
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _items[5].count > 0
                                ? MyContainer(
                                    child: SizedBox(
                                      height: 300,
                                      child: Column(
                                        children: [
                                          SensorDisplay(items: _items),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            //items
                            MyContainer(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyTitle(title: "Items", children: itemList),
                                ],
                              ),
                            ),
                            //resources
                            MyContainer(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  MyTitle(
                                    title: "Resources",
                                    children: [
                                      MyResource(
                                        title: "water",
                                        resource:
                                            "${_resources[Resource.WATER.index]}",
                                      ),
                                      _items[1].count > 0
                                          ? MyResource(
                                              title: "h2",
                                              resource:
                                                  "${_resources[Resource.HYDROGEN.index]}",
                                            )
                                          : SizedBox(),
                                      _items[1].count > 0
                                          ? MyResource(
                                              title: "o2",
                                              resource:
                                                  "${_resources[Resource.OXYGEN.index]}",
                                            )
                                          : SizedBox(),
                                      SizedBox(height: 10),
                                      _items[0].count > 0
                                          ? ElevatedButton(
                                              onPressed: gatherWater,
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(200, 30),
                                              ),
                                              child: Text("Gather Water"),
                                            )
                                          : SizedBox(),
                                      SizedBox(height: 10),
                                      _items[1].count > 0
                                          ? ElevatedButton(
                                              onPressed:
                                                  _resources[Resource
                                                          .WATER
                                                          .index] >=
                                                      2
                                                  ? electrolyzeWater
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(200, 30),
                                              ),
                                              child: Text("Electrolyze Water"),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //3rd tab - messages
                      Center(
                        child: MyContainer(
                          // messages
                          child: MyTitle(
                            title: "Messages",
                            children: [
                              SizedBox(width: 200, child: Text(_latestMessage)),
                              SizedBox(height: 10),
                              _latestMessage == ""
                                  ? SizedBox(width: 0)
                                  : ElevatedButton(
                                      onPressed: null,
                                      child: Text("Fill His Tank with 20 O2"),
                                    ),
                              SizedBox(height: 10),
                              _latestMessage == ""
                                  ? SizedBox(width: 0)
                                  : ElevatedButton(
                                      onPressed: null,
                                      child: Text("Watch Him Suffer"),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 100),

                // FloatingActionButton(
                //   onPressed: _incrementCounter,
                //   tooltip: 'Increment',
                //   child: const Icon(Icons.add),
                // ),
              ],
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          ),
        );
      },
    );
  }
}
