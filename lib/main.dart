import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Null Fasting'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

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
            Text('Start', style: startLabelStyle),
            Text(DateFormat("EEEE, H:Hm").format(startDate ?? DateTime(0)), style: dateLabelStyle),
            ElevatedButton(
              style: changeButtonStyle,
              onPressed: () => selectStartDate(context),
              child: const Text('Edit'),
            ),
          ],
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

class _MyHomePageState extends State<MyHomePage> {
  DateTime start = DateTime.now(); 
  Duration fastDuration = Duration(hours: 16);
  Timer? tickTimer;
  Duration elapsed = Duration();
  double elapsedPercent = 0;
  Duration remaining = Duration();

  @override
  void initState() {
    super.initState();
    tickTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now();
        elapsed = now.difference(start);
        remaining = fastDuration - elapsed;
        elapsedPercent = elapsed.inSeconds / fastDuration.inSeconds;
      });
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

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                new CircularPercentIndicator(
                    radius: 290.0,
                    lineWidth: 5.0,
                    animation: false,
                    percent: 1,
                    progressColor: Colors.orange,
                  ),
                new CircularPercentIndicator(
                    radius: 320.0,
                    lineWidth: 35.0,
                    animation: false,
                    percent: (elapsedPercent <= 1) ? elapsedPercent : 1,
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
                ],
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
      ),
    );
  }
}