import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import './models/fast.dart';
import 'package:fl_chart/fl_chart.dart';

class StartTime extends StatelessWidget {
  const StartTime({
    Key? key,
    this.startDate,
    this.onStartDateChange,
  }) : super(key: key);

  final DateTime? startDate;
  final ValueSetter<DateTime>? onStartDateChange;

  void selectStartDate(BuildContext context) {
    DatePicker.showDateTimePicker(
      context,
      currentTime: startDate,
      showTitleActions: true,
      maxTime: DateTime.now(),
      onConfirm: (date) {
        if (onStartDateChange != null) {
          onStartDateChange!(date);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double fontSize = 14;
    final TextStyle editLabelStyle = TextStyle(
      color: Theme.of(context).primaryColor,
    );
    final TextStyle? startLabelStyle = Theme.of(context).textTheme.subtitle2;
    final TextStyle? dateLabelStyle = Theme.of(context).textTheme.subtitle1;
    return GestureDetector(
      onTap: () => selectStartDate(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Start', style: startLabelStyle),
          Text(DateFormat("EEEE, kk:mm").format(startDate ?? DateTime(0)), style: dateLabelStyle),
          Row(
            children: <Widget>[
              Text('Edit ', style: editLabelStyle),
              Icon(Icons.mode_edit, size: fontSize, color: Theme.of(context).primaryColor),
            ],
          ),
        ],
      ),
    );
  }
}

class GoalTime extends StatelessWidget {
  const GoalTime({
    Key? key,
    this.startDate,
    this.duration = const Duration(),
  }) : super(key: key);

  final DateTime? startDate;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final TextStyle? startLabelStyle = Theme.of(context).textTheme.subtitle2;
    final TextStyle? dateLabelStyle = Theme.of(context).textTheme.subtitle1;
    DateTime goalTime = DateTime(0);
    if (startDate != null) {
      goalTime = startDate!.add(duration);
    }
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Goal', style: startLabelStyle),
            Text(DateFormat("EEEE, kk:mm").format(goalTime), style: dateLabelStyle),
          ],
        );
  }
}

class RecentFastsChart extends StatelessWidget {
  final Isar isar;
  const RecentFastsChart({
    Key? key,
    required this.isar,
    required this.startDate,
    required this.targetDuration,
  }) : super(key: key);

  final DateTime? startDate;
  final Duration targetDuration;

  final double barWidth = 20;
  final double targetHours = 20;

  BarChartGroupData createBar(int x, double y, double width, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: (y <= targetHours) ? y : targetHours,
          colors: [color],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: targetHours,
            colors: [Colors.black12],
          )
        ),
      ],
    );
  }

  BarChartData data(List<Fast> recentFasts) {
    List<BarChartGroupData> barGroups = [];
    for(int id = 0; id < recentFasts.length; id++) {
      var fast = recentFasts[id];
      final Duration duration = (fast.end != null) ? fast.end!.difference(fast.start) : const Duration();
      final int hours = duration.inHours;
      final bool goalReached = duration.compareTo(targetDuration) >= 0;
      barGroups.add(createBar(id, hours.toDouble(), barWidth, goalReached ? Colors.green : Colors.orange));
    }

    return BarChartData(
      barGroups: barGroups,
      alignment: BarChartAlignment.center,
      groupsSpace: barWidth,
      barTouchData: BarTouchData(enabled: false),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14),
          getTitles: (double value) {
            Fast fast = recentFasts[value.toInt()];
            if (fast.end != null) {
              final int hours = fast.end!.difference(fast.start).inHours;
              return '${hours}h';
            } else {
              return ''; // Fast not ended
            }
          }
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14),
          margin: 10,
          getTitles: (double value) {
            Fast fast = recentFasts[value.toInt()];
            return DateFormat("E").format(fast.start);
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      maxY: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Fast> recentFasts = isar.fasts.where().sortByStartDesc().limit(7).findAllSync();
    
    recentFasts.sort((a, b) => a.start.compareTo(b.start));
    if (recentFasts.length > 7) {
      recentFasts = recentFasts.sublist(recentFasts.length - 7);
    }

    return Expanded(child: BarChart(data(recentFasts)));
  }
}

class CurrentFastPage extends StatefulWidget {
  final Isar isar;
  const CurrentFastPage({Key? key, required this.isar}) : super(key: key);

  @override
  State<CurrentFastPage> createState() => CurrentFastPageState();
}

class CurrentFastPageState extends State<CurrentFastPage> {
  Timer? tickTimer;
  Duration elapsed = const Duration();
  double elapsedPercent = 0;
  Duration remaining = const Duration();
  Fast? latestFast;
  int targetHours = 16;

  bool isCurrentlyFasting() {
    if (latestFast == null || latestFast?.end != null) {
      return false;
    } else {
      return true;
    }
  }

  void tickUpdate() {
    if (isCurrentlyFasting()) {
      setState(() {
        DateTime now = DateTime.now();
        elapsed = now.difference(latestFast!.start);
        final Duration targetDuration = Duration(hours: targetHours);
        remaining = targetDuration - elapsed;
        elapsedPercent = elapsed.inSeconds / targetDuration.inSeconds;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    latestFast = widget.isar.fasts.where().sortByStartDesc().findFirstSync();
    targetHours = latestFast?.targetHours ?? 16;

    tickUpdate();
    tickTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      tickUpdate();
    });
  }
  

  @override
  void dispose() {
    super.dispose();
    tickTimer?.cancel();
  }

  // Expects the latestFast to have ended.
  void startNewFast(DateTime startDate) {
    Fast newFast = Fast(start: startDate, targetHours: targetHours);
    widget.isar.writeTxnSync((isar) {
      newFast.id = widget.isar.fasts.putSync(newFast);
    });
    latestFast = newFast;
  }

  void setStartDate(DateTime newStartDate) {
    setState(() {
      if (isCurrentlyFasting()) {
        // Update start time
        latestFast?.start = newStartDate;
        widget.isar.writeTxn((isar) async {
          widget.isar.fasts.put(latestFast!);
        });
      } else {
        // Start a new fast
        startNewFast(newStartDate);
      }
    });
  }

  String elapsedTimeLabel() {
    int percent = (elapsedPercent * 100).round();
    return 'Elapsed time ($percent%)';
  }

  String remainingTimeLabel() {
    int percent = 100 - (elapsedPercent * 100).round();
    if (percent < 0) return '';
    return 'Remaining ($percent%)';
  }

  void toggleFast() {
    if (isCurrentlyFasting()) {
      latestFast?.end = DateTime.now();
      // TODO: Add confirmation before ending and saving the fast
      widget.isar.writeTxn((isar) async {
        widget.isar.fasts.put(latestFast!);
      });

      /*setState(() {
        currentFastBox.put('start', null);
        elapsed = Duration.zero;
        elapsedPercent = 0;
        remaining = Duration.zero;
        remaining = Duration.zero;
      });*/
    } else {
      startNewFast(DateTime.now());
    }
  }

  String changeDurationButtonLabel() {
    int hours = targetHours;
    return '${hours}h';
  }

  Widget fastingDurationCard(Duration cardDuration) {
    int hoursFasting = cardDuration.inHours;
    int hoursEating = 24 - hoursFasting;

    final TextStyle? ratioStyle = Theme.of(context).textTheme.headline5;

    Color color = Colors.green;
    if (hoursFasting >= 16) color = Colors.amber;
    if (hoursFasting >= 20) color = Colors.orange;

    return GestureDetector(
      onTap: () {
        setState(() {
          targetHours = cardDuration.inHours;
          if (isCurrentlyFasting()) {
            latestFast?.targetHours = targetHours;
            widget.isar.writeTxn((isar) async {
              widget.isar.fasts.put(latestFast!);
            });
          }
        });
        Navigator.pop(context);
      },
      child: Card(
        color: color,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("$hoursFasting:$hoursEating", style: ratioStyle),
                  const Spacer(),
                  if (cardDuration.inHours == targetHours) const Icon(Icons.check),
                ],
              ),
              Text("Fast for $hoursFasting hours, then eat for $hoursEating hours."),
            ],
          ),
        ),
      ),
    );
  }

  void changeFastDuration(BuildContext context) {
    final TextStyle? titleStyle = Theme.of(context).textTheme.headline4;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Fasting times', style: titleStyle),
              const SizedBox(height: 5),
              const Text('Choose your fasting duration'),
              const SizedBox(height: 10),
              Expanded(child: GridView.count(
                childAspectRatio: 1.9,
                crossAxisCount: 2,
                children: <Widget>[
                  // Easy
                  fastingDurationCard(const Duration(hours: 12)),
                  fastingDurationCard(const Duration(hours: 13)),
                  fastingDurationCard(const Duration(hours: 14)),
                  fastingDurationCard(const Duration(hours: 15)),
                  // Medium
                  fastingDurationCard(const Duration(hours: 16)),
                  fastingDurationCard(const Duration(hours: 17)),
                  fastingDurationCard(const Duration(hours: 18)),
                  fastingDurationCard(const Duration(hours: 19)),
                  // Hard
                  fastingDurationCard(const Duration(hours: 20)),
                  fastingDurationCard(const Duration(hours: 21)),
                  fastingDurationCard(const Duration(hours: 22)),
                  fastingDurationCard(const Duration(hours: 23)),
                ],
              )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle toggleFastButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      elevation: 5,
    );

    const double maxProgress = 0.95;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 100),
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 320.0,
                  lineWidth: 35.0,
                  animation: false,
                  percent: maxProgress,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.black12,
                  backgroundColor: Colors.transparent,
                ),
                CircularPercentIndicator(
                  radius: 320.0,
                  lineWidth: 35.0,
                  animation: false,
                  percent: (elapsedPercent <= 1) ? (elapsedPercent * maxProgress) : maxProgress,
                  center: 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(elapsedTimeLabel(), style: Theme.of(context).textTheme.subtitle1),
                        Text(
                          elapsed.toString().split('.').first,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(remainingTimeLabel(), style: Theme.of(context).textTheme.subtitle2),
                        Text(
                          (elapsedPercent >= 1) ? '' : remaining.toString().split('.').first,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: (elapsedPercent >= 1) ? Colors.green : Colors.orange,
                  backgroundColor: Colors.transparent,
                ),
                Positioned(
                  top: -10,
                  right: -30,
                  child: TextButton(
                    onPressed: () => changeFastDuration(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(changeDurationButtonLabel(), style: const TextStyle(fontSize: 20)),
                        Icon(Icons.mode_edit, size: 20, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StartTime(
                    startDate: isCurrentlyFasting() ? latestFast?.start : null,
                    onStartDateChange: setStartDate
                  ),
                  const Spacer(),
                  GoalTime(
                    startDate: isCurrentlyFasting() ? latestFast?.start : null,
                    duration: Duration(hours: targetHours),
                  ),
                ],
              ),
              margin: const EdgeInsets.all(30),
            ),
            ElevatedButton(
              style: toggleFastButtonStyle,
              onPressed: toggleFast,
              child: (isCurrentlyFasting())
                ? const Text('Start fast')
                : const Text('End fast'),
            ),
            const SizedBox(height: 20),
            RecentFastsChart(
              isar: widget.isar,
              startDate: latestFast?.start,
              targetDuration: Duration(hours: targetHours),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
  }
}
