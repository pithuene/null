import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    ProviderScope(child: NullApp(isar: isar)),
  );
}

final selectedTabIndexProvider = StateProvider<int>((ref) => 0);

class NullApp extends ConsumerWidget {
  final Isar isar;

  const NullApp({
    Key? key,
    required this.isar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(
        isar: isar,
        selectedTabIndex: ref.watch(selectedTabIndexProvider),
        setSelectedTabIndex: (int index) {
          ref.read(selectedTabIndexProvider.notifier).state = index;
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
