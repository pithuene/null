import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import './models/fast.dart';
import './currentfast.dart';
import './fastlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open(
    schemas: [FastSchema],
    directory: dir.path,
  );
  runApp(
    NullApp(isar: isar),
  );
}

class NullApp extends StatefulWidget {
  final Isar isar;

  NullApp({
    Key? key,
    required this.isar,
  });

  @override
  NullAppState createState() => NullAppState();
}

class NullAppState extends State<NullApp> {
  int selectedTabIndex = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(
        isar: widget.isar,
        selectedTabIndex: selectedTabIndex,
        setSelectedTabIndex: (int index) {
          setState(() {
            selectedTabIndex = index;
          });
        }
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
        onTap: (int index) {
          setSelectedTabIndex(index);
        },
      ),
      body: SafeArea(child: pages.elementAt(selectedTabIndex)),
    );
  }
}
