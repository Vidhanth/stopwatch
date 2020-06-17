import 'dart:async';
import 'package:flutter/foundation.dart';

class StopWatch with ChangeNotifier {
  int milliseconds = 00;
  int seconds = 00;
  int minutes = 00;
  int hours = 00;
  bool _wasReset = true;
  Timer _timer;

  bool get wasReset => _wasReset;

  bool get isTimerRunning {
    if (_timer != null) {
      return _timer.isActive;
    }
    return false;
  }


  void start() {
    _wasReset = false;
    Timer.periodic(
      Duration(milliseconds: 10),
      (Timer timer) {
        _timer = timer;
        if(milliseconds == 99){
          milliseconds = 0;
          incrementSeconds();
        }else
          milliseconds++;
        notifyListeners();
      },
    );
  }

  void incrementSeconds() {
    if (seconds == 59) {
      incrementMinutes();
      seconds = 00;
    } else {
      seconds++;
    }
  }

  void incrementMinutes() {
    if (minutes == 59) {
      hours++;
      minutes = 00;
    } else {
      minutes++;
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void reset() {
    _wasReset = true;
    _timer?.cancel();
    _timer = null;
    seconds = 0;
    milliseconds = 0;
    minutes = 0;
    hours = 0;
    notifyListeners();
  }
}
