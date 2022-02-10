import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hive/hive.dart';
import './models/fast.dart';

class FastListPage extends StatefulWidget {
  const FastListPage({Key? key}) : super(key: key);

  @override
  State<FastListPage> createState() => FastListPageState();
}

class FastListPageState extends State<FastListPage> {
  late final Box fastsBox;

  @override
  void initState() {
    super.initState();
    fastsBox = Hive.box('fasts');
  }

  String formatDurationHH(Duration dur) {
    final int hours = dur.inHours;
    return '${hours}h';
  }

  String formatDurationHHmm(Duration dur) {
    final int hours = dur.inHours;
    final int minutesVal = dur.inMinutes % 60;
    final String minutes = minutesVal.toString().padLeft(2, '0');
    return '${hours}h ${minutes}m';
  }

  String formatWeekdayDuration(Fast fast) {
    final String startDay = DateFormat("EEEE").format(fast.start);
    if (fast.start.weekday == fast.end.weekday) {
      return startDay;
    } else {
      final String endDay = DateFormat("EEEE").format(fast.end);
      return '$startDay to $endDay';
    }
  }

  Widget getFastListEntry(Fast fast) {
    final Duration duration = fast.end.difference(fast.start);
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(formatWeekdayDuration(fast), style: Theme.of(context).textTheme.headline5),
            Row(
              children: <Widget>[
                Text(formatDurationHHmm(duration)),
                const Text(" / "),
                Text(formatDurationHH(fast.targetDuration)),
              ]
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> fasts = fastsBox.values.toList();
    fasts.sort((a, b) => b.start.compareTo(a.start));
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Completed fasts", style: Theme.of(context).textTheme.headline4),
          Expanded(
            child: new ListView.builder(
              itemCount: fasts.length,
              itemBuilder: (context, index) {
                Fast fast = fasts[index];
                return getFastListEntry(fast);
              },
            ),
          ),
        ],
      ),
    );
  }
}
