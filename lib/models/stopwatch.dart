import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch/components/header.dart';
import 'package:stopwatch/components/stopwatch_controls.dart';
import 'package:stopwatch/services/constants.dart';

class StopWatch with ChangeNotifier {
  int milliseconds = 00;
  int seconds = 00;
  int minutes = 00;
  int hours = 00;
  bool _wasReset = true;
  Timer _timer;
  SharedPreferences _prefs;
  FlutterTts _tts = FlutterTts();

  bool get wasReset => _wasReset;

  bool get isTimerRunning {
    if (_timer != null) {
      return _timer.isActive;
    }
    return false;
  }

  void start() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    _wasReset = false;
    Timer.periodic(
      Duration(milliseconds: 10),
      (Timer timer) async {
        _timer = timer;
        if (milliseconds == 99) {
          milliseconds = 0;
          incrementSeconds();
        } else
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
    runActions();
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

  void runActions() async {
    print("running actions $seconds");

    if (_prefs.getBool(intervalActionsKey)) {
      if (_prefs.getBool(playSoundKey)) {
        //TODO Play interval sound
      }
      if (_prefs.getBool(autoLapKey)) {
        //TODO autoLap
      }
    }

    if (_prefs.getBool(specificActionsKey)) {
      List<String> sp = _prefs.getStringList(specificTimeKey);
      int spHour = int.parse(sp[0]);
      int spMin = int.parse(sp[1]);
      int spSec = int.parse(sp[2]);

      if (spHour == hours && spMin == minutes && spSec == seconds) {
        if (_prefs.getBool(specificPlaySoundKey)) {
          //TODO play specific sound
        }
        if(_prefs.getBool(speakTimeKey))
          _tts.speak(getSpeechString());

        if(_prefs.getBool(specificAutoLapKey))
          addLap(getContext);

        if (_prefs.getBool(stopClockKey)) {
          stop();
        }
      }
    }
  }

  String getSpeechString() {
    String hourText = "";
    String minText = "";
    String secText = "";
    String hourAnd = "";
    String minAnd = "";
    String fin;
    String al;

    if (hours > 0) {
      if (hours == 1)
        hourText = "$hours hour";
      else
        hourText = "$hours hours";

      if((minutes==0 && seconds!=0)||(minutes!=0 && seconds==0))
        hourAnd = "and";

    }

    if(minutes>0){
      if(minutes == 1)
        minText = "$minutes minute";
      else
        minText = "$minutes minutes";

      if(seconds>0)
        minAnd = "and";

    }

    if(seconds>0){
      if(seconds == 1)
        secText = "$seconds second";
      else
        secText = "$seconds seconds";
    }

    fin = "$hourText $hourAnd $minText $minAnd $secText".trim();
    if(fin.endsWith("s"))
      al = "$fin have passed.";
    else
      al = "$fin has passed.";

    return al;



  }
}
