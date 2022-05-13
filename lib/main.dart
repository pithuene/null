import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import './models/fast.dart';
import './currentfast.dart';
import './fastlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  int selectedTabIndex = 0;
  final isar = await Isar.open(
    schemas: [FastSchema],
    directory: dir.path,
  );
  runApp(
    MyApp(
      isar: isar,
      selectedTabIndex: selectedTabIndex,
      setSelectedTabIndex: (int tabIndex) {
        selectedTabIndex = tabIndex;
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  final Isar isar;
  final int selectedTabIndex;
  final Function setSelectedTabIndex;

  const MyApp({
    Key? key,
    required this.isar,
    required this.selectedTabIndex,
    required this.setSelectedTabIndex,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(
        isar: isar,
        selectedTabIndex: selectedTabIndex,
        setSelectedTabIndex: setSelectedTabIndex
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Isar isar;
  final int selectedTabIndex;
  final Function setSelectedTabIndex;

  const MyHomePage({
    Key? key,
    required this.isar,
    required this.selectedTabIndex,
    required this.setSelectedTabIndex
  }) : super(key: key);

  void onTabTap(int index) {
    setSelectedTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      CurrentFastPage(isar: isar),
      const Text('Page 2'),
      FastListPage(isar: isar),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.waterfall_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        currentIndex: selectedTabIndex,
        selectedItemColor: Colors.amber[800],
        onTap: onTabTap,
      ),
      body: pages.elementAt(selectedTabIndex),
    );
  }
}
