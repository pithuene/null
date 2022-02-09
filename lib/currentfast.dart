import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
    return new GestureDetector(
      onTap: () => selectStartDate(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Start', style: startLabelStyle),
          Text(DateFormat("EEEE, H:Hm").format(startDate ?? DateTime(0)), style: dateLabelStyle),
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
    this.duration,
  }) : super(key: key);

  final DateTime? startDate;
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle changeButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 12),
      padding: EdgeInsets.all(10),
    );
    final TextStyle? startLabelStyle = Theme.of(context).textTheme.subtitle2;
    final TextStyle? dateLabelStyle = Theme.of(context).textTheme.subtitle1;
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Goal', style: startLabelStyle),
            Text(DateFormat("EEEE, H:Hm").format(startDate ?? DateTime(0)), style: dateLabelStyle),
          ],
        );
  }
}

class CurrentFastPage extends StatefulWidget {
  const CurrentFastPage({Key? key}) : super(key: key);

  @override
  State<CurrentFastPage> createState() => CurrentFastPageState();
}

class CurrentFastPageState extends State<CurrentFastPage> {
  DateTime? start;
  Duration fastDuration = Duration(hours: 16);
  Timer? tickTimer;
  Duration elapsed = Duration();
  double elapsedPercent = 0;
  Duration remaining = Duration();

  @override
  void initState() {
    super.initState();
    tickTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (start != null) {
        setState(() {
            DateTime now = DateTime.now();
            elapsed = now.difference(start!);
            remaining = fastDuration - elapsed;
            elapsedPercent = elapsed.inSeconds / fastDuration.inSeconds;
        });
      }
    });
  }

  void setStartDate(DateTime newStartDate) {
    setState(() {
      start = newStartDate;
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
    bool wasFasting = start != null;
    if (wasFasting) {
      // TODO: Save finished fast
      setState(() {
        start = null;
        elapsed = Duration.zero;
        elapsedPercent = 0;
        remaining = Duration.zero;
        remaining = Duration.zero;
      });
    } else {
      // Start fast
      setState(() {
        start = DateTime.now();
      });
    }
  }

  String changeDurationButtonLabel() {
    int hours = fastDuration.inHours;
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
          fastDuration = Duration(hours: cardDuration.inHours) ;
        });
        Navigator.pop(context);
      },
      child: Card(
        color: color,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("${hoursFasting}:${hoursEating}", style: ratioStyle),
                  Spacer(),
                  if (fastDuration.compareTo(cardDuration) == 0) Icon(Icons.check),
                ],
              ),
              Text("Fast for ${hoursFasting} hours, then eat for ${hoursEating} hours."),
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
          margin: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Fasting times', style: titleStyle),
              SizedBox(height: 5),
              const Text('Choose your fasting duration'),
              SizedBox(height: 10),
              Expanded(child: GridView.count(
                childAspectRatio: 1.9,
                crossAxisCount: 2,
                children: <Widget>[
                  // Easy
                  fastingDurationCard(Duration(hours: 12)),
                  fastingDurationCard(Duration(hours: 13)),
                  fastingDurationCard(Duration(hours: 14)),
                  fastingDurationCard(Duration(hours: 15)),
                  // Medium
                  fastingDurationCard(Duration(hours: 16)),
                  fastingDurationCard(Duration(hours: 17)),
                  fastingDurationCard(Duration(hours: 18)),
                  fastingDurationCard(Duration(hours: 19)),
                  // Hard
                  fastingDurationCard(Duration(hours: 20)),
                  fastingDurationCard(Duration(hours: 21)),
                  fastingDurationCard(Duration(hours: 22)),
                  fastingDurationCard(Duration(hours: 23)),
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
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      elevation: 5,
    );

    final double maxProgress = 0.95;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100),
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                new CircularPercentIndicator(
                  radius: 320.0,
                  lineWidth: 35.0,
                  animation: false,
                  percent: maxProgress,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.black12,
                  backgroundColor: Colors.transparent,
                ),
                new CircularPercentIndicator(
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
                        Text(changeDurationButtonLabel(), style: TextStyle(fontSize: 20)),
                        Icon(Icons.mode_edit, size: 20, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: toggleFastButtonStyle,
              onPressed: toggleFast,
              child: (start == null) ?  const Text('Start fast') : const Text('End fast'),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StartTime(startDate: start, onStartDateChange: setStartDate),
                  Spacer(),
                  GoalTime(startDate: start, duration: fastDuration),
                ],
              ),
              margin: EdgeInsets.all(30),
            ),
          ],
        ),
      );
  }
}
