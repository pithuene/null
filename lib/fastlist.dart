import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
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

  void deleteFastEntry(Tuple2<int, Fast> fast) {
    setState(() {
      fastsBox.delete(fast.item1);
    });
  }

  Widget getFastListEntry(Tuple2<int, Fast> fast) {
    final Duration duration = fast.item2.end.difference(fast.item2.start);
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(formatWeekdayDuration(fast.item2), style: Theme.of(context).textTheme.headline5),
            Row(
              children: <Widget>[
                Text(formatDurationHHmm(duration)),
                const Text(" / "),
                Text(formatDurationHH(fast.item2.targetDuration)),
                Spacer(),
                TextButton(onPressed: () => deleteFastEntry(fast), child: const Text("Delete"))
              ]
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Tuple2<int, Fast>> fasts = [];
    fastsBox.keys.forEach((key) {
      fasts.add(Tuple2<int, Fast>(key, fastsBox.get(key)));
    });
    // TODO: This will not scale
    fasts.sort((a, b) => b.item2.start.compareTo(a.item2.start));
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
                return getFastListEntry(fasts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
