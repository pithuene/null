import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import './models/fast.dart';

class FastListPage extends StatefulWidget {
  final Isar isar;
  const FastListPage ({Key? key, required this.isar}) : super(key: key);

  @override
  State<FastListPage> createState() => FastListPageState();
}

class FastListPageState extends State<FastListPage> {

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
    if (fast.start.weekday == fast.end?.weekday) {
      return startDay;
    } else if (fast.end != null) {
      final String endDay = DateFormat("EEEE").format(fast.end!);
      return '$startDay to $endDay';
    } else {
      return 'From $startDay ongoing';
    }
  }

  void deleteFastEntry(Fast fast) {
    setState(() {
      widget.isar.writeTxnSync((isar) {
        if (fast.id != null) {
          isar.fasts.deleteSync(fast.id!);
        }
      });
    });
  }

  Widget getFastListEntry(BuildContext context, Fast fast) {
    final DateTime fastEnd = fast.end ?? DateTime.now();
    final Duration duration = fastEnd.difference(fast.start);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              formatWeekdayDuration(fast),
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: <Widget>[
                Text(formatDurationHHmm(duration)),
                const Text(" / "),
                Text(fast.targetHours.toString() + 'h'),
                const Spacer(),
                TextButton(
                  onPressed: () => deleteFastEntry(fast),
                  child: const Text("Delete"),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Fast> fasts = widget.isar.fasts
                           .where()
                           .sortByStart()
                           .findAllSync();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("Completed fasts", style: Theme.of(context).textTheme.headline4),
            padding: const EdgeInsets.all(10.0),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fasts.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: getFastListEntry(context, fasts[index]),
                );
              },
            ),
          ),
        ],
      );
  }
}
