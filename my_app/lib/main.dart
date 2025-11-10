import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_container.dart';
import 'my_title.dart';
import 'my_resource.dart';

void main() {
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
  final List<int> _items = [0, 0, 0, 0, 0];
  final List<int> _costs = [1, 20, 100, 100, 40];
  final List<String> _names = [
    "Bucket",
    "Electrolyzer",
    "Solar Panel",
    "Pump",
    "Battery",
  ];
  final List<int> _resourcePrices = [0, 0, 0, 0];
  final List<String> _resourceNames = ["Water", "H2", "O2"];
  final Random _rng = Random();
  //Timer? _timer;
  late SharedPreferences _prefs;
  late TabController _tabController;
  String _latestMessage = "";
  int _h2o = 0;
  int _h2 = 0;
  int _o2 = 0;
  int _quanta = 0;
  int _energy = 0;

  void setPrefs() {
    _prefs.setInt('h2o', _h2o);
    _prefs.setInt('o2', _o2);
    _prefs.setInt('h2', _h2);
    _prefs.setInt('energy', _energy);
    _prefs.setInt('quanta', _quanta);
    _prefs.setInt('items0', _items[0]);
    _prefs.setInt('items1', _items[1]);
  }

  void gatherWater() async {
    setState(() {
      _h2o++;
    });
    setPrefs();
  }

  void electrolyzeWater() async {
    setState(() {
      _h2o = _h2o - 2;
      _h2 = _h2 + 2;
      _o2++;
      if (_o2 > 50 && _events[0] == 0) {
        _tabController.animateTo(2);
        _events[0]++;
        _latestMessage =
            "A stranger is here, begging for oxygen. \n Take what is offered and give 20 oxygen \nOR\n wait for the inevitable and take what is left.";
      }
    });
    setPrefs();
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

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _h2o = _prefs.getInt('h2o') ?? 0;
      _o2 = _prefs.getInt('o2') ?? 0;
      _h2 = _prefs.getInt('h2') ?? 0;
      _quanta = _prefs.getInt('quanta') ?? 1;
      _energy = _prefs.getInt('energy') ?? 0;
      _items[0] = _prefs.getInt('items0') ?? 0;
      _items[1] = _prefs.getInt('items1') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initSharedPreferences();
    _marketTimer();
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
      if (_items[i] > 0) {
        itemList.add(Text(_names[i]));
      }
    }
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
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Text('The Chemistry Set'),
              ),
              ListTile(
                title: const Text('Save Progress (auto)'),
                tileColor: Colors.grey,
                onTap: null,
              ),
              ListTile(
                title: const Text('Reset Progress'),
                tileColor: Colors.red,
                onTap: () {
                  _h2o = 0;
                  _o2 = 0;
                  _h2 = 0;
                  _quanta = 1;
                  for (int i = 0; i < _items.length; i++) {
                    _items[i] = 0;
                  }
                  setState(() {});
                },
              ),
              ListTile(
                title: const Text('Cheat Progress'),
                tileColor: Colors.orange,
                onTap: () {
                  _h2o += 1000;
                  _o2 += 1000;
                  _h2 += 1000;
                  _quanta = 1000;
                  for (int i = 0; i < _items.length; i++) {
                    _items[i] = 10;
                  }
                  setState(() {});
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
            _items[2] > 0
                ? Container(
                    color: Colors.yellow,
                    child: Row(
                      children: [
                        MyResource(
                          title: "Energy",
                          resource:
                              "$_energy / ${_items[2] * 10 + _items[4] * 100}",
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //the shop and the market
                        MyContainer(
                          // the shop
                          child: MyTitle(
                            title: "The Shop",
                            children: <Widget>[
                              MyResource(title: "Quanta", resource: "$_quanta"),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _items[0] > 0 || _quanta < _costs[0]
                                    ? null
                                    : () {
                                        _items[0]++;
                                        _quanta -= _costs[0];
                                        setPrefs();
                                        setState(() {});
                                      },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(200, 30),
                                ),
                                child: Text(
                                  _items[0] == 0
                                      ? "Buy ${_names[0]}: ${_costs[0]}"
                                      : "${_names[0]} Owned",
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _items[1] > 0 || _quanta < _costs[1]
                                    ? null
                                    : () {
                                        _items[1]++;
                                        _quanta -= _costs[1];
                                        setPrefs();
                                        setState(() {});
                                      },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(200, 30),
                                ),
                                child: Text(
                                  _items[1] == 0
                                      ? "Buy ${_names[1]}: ${_costs[1]}"
                                      : "${_names[1]} Owned",
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _quanta < _costs[2]
                                    ? null
                                    : () {
                                        _items[2]++;
                                        _quanta -= _costs[2];
                                        setPrefs();
                                        setState(() {});
                                      },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(200, 50),
                                ),
                                child: Text(
                                  "Buy ${_names[2]}: ${_costs[2]}\n   ${_items[2]} Owned",
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _quanta < _costs[3]
                                    ? null
                                    : () {
                                        _items[3]++;
                                        _quanta -= _costs[3];
                                        setPrefs();
                                        setState(() {});
                                      },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(200, 50),
                                ),
                                child: Text(
                                  "Buy ${_names[3]}: ${_costs[3]}\n   ${_items[3]} Owned",
                                ),
                              ),
                            ],
                          ),
                        ),
                        MyContainer(
                          child: MyTitle(
                            title: "The Market",
                            children: [
                              ElevatedButton(
                                onPressed: _h2o > 0
                                    ? () {
                                        _h2o--;
                                        _quanta += _resourcePrices[0];
                                        setPrefs();
                                        setState(() {});
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(200, 30),
                                ),
                                child: MyResource(
                                  title: "${_resourceNames[0]} ($_h2o)",
                                  resource: "${_resourcePrices[0]}q",
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _h2 > 0
                                    ? () {
                                        _h2--;
                                        _quanta += _resourcePrices[1];
                                        setPrefs();
                                        setState(() {});
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(200, 30),
                                ),
                                child: MyResource(
                                  title: "${_resourceNames[1]} ($_h2)",
                                  resource: "${_resourcePrices[1]}q",
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _o2 > 0
                                    ? () {
                                        _o2--;
                                        _quanta += _resourcePrices[2];
                                        setPrefs();
                                        setState(() {});
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(200, 30),
                                ),
                                child: MyResource(
                                  title: "${_resourceNames[2]} ($_o2)",
                                  resource: "${_resourcePrices[2]}q",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //items and resources
                        MyContainer(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyTitle(title: "Items", children: itemList),
                            ],
                          ),
                        ),
                        MyContainer(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              MyTitle(
                                title: "Resources",
                                children: [
                                  MyResource(title: "water", resource: "$_h2o"),
                                  MyResource(title: "h2", resource: "$_h2"),
                                  MyResource(title: "o2", resource: "$_o2"),
                                  SizedBox(height: 10),
                                  _items[0] > 0
                                      ? ElevatedButton(
                                          onPressed: gatherWater,
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(200, 30),
                                          ),
                                          child: Text("Gather Water"),
                                        )
                                      : SizedBox(),
                                  SizedBox(height: 10),
                                  _items[1] > 0
                                      ? ElevatedButton(
                                          onPressed: _h2o >= 2
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
  }
}
