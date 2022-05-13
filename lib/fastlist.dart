import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import './models/fast.dart';

class FastListPage extends StatelessWidget {
  final Isar isar;

  const FastListPage({
    Key? key,
    required this.isar
  }) : super(key: key);

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
    isar.writeTxn((isar) async {
      if (fast.id != null) {
        isar.fasts.delete(fast.id!);
      }
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
                Text(fast.targetHours.toString()),
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
    List<Fast> fasts = isar.fasts
                           .where()
                           .sortByStart()
                           .findAllSync();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Completed fasts", style: Theme.of(context).textTheme.headline4),
          Expanded(
            child: ListView.builder(
              itemCount: fasts.length,
              itemBuilder: (context, index) {
                return getFastListEntry(context, fasts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
