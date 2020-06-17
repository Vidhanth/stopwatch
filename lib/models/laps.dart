import 'package:flutter/foundation.dart';

class Laps with ChangeNotifier {

  List<String> lapsList = [];





  void addLap(int hour, int minute, int second, int millisecond){


    String hourString = hour == 0 ? "" : hour<10 ? "0$hour :" : "$hour :";
    String minuteString = minute<10 ? "0$minute" : minute.toString();
    String secondString = second<10 ? "0$second" : second.toString();
    String milliString = millisecond<10 ? "0$millisecond" : millisecond.toString();

    String lap = "$hourString $minuteString : $secondString : $milliString";
    if(!lapsList.contains(lap)){
      lapsList.add(lap);
      notifyListeners();
    }

  }

  void resetLaps(){

    lapsList.clear();
    notifyListeners();

  }

}