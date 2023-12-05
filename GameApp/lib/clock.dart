// clock_ui.dart

import 'dart:async';
import 'package:flutter/material.dart';

class ClockUI extends StatefulWidget {
  final Function onTimeout;

  ClockUI({required this.onTimeout});

  @override
  _ClockUIState createState() => _ClockUIState();
}

class _ClockUIState extends State<ClockUI> {
  int _timerSeconds = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    stopTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          // Timer has reached 0, show popup and update result
          _timer.cancel();
          widget.onTimeout();
        }
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
    _timer = Timer(Duration.zero, () {});
  }
  void resetTimer(int initialSeconds) {
    setState(() {
      _timerSeconds = initialSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Time Remain: $_timerSeconds seconds',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
