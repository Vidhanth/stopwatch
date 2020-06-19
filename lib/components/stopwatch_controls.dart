import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:stopwatch/models/laps.dart';
import 'package:stopwatch/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:stopwatch/models/stopwatch.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/services/custom_buttons.dart';
import 'package:wakelock/wakelock.dart';


BuildContext _context;

class StopWatchControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    _context = context;
    StopWatch stopwatch = Provider.of<StopWatch>(context);
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w,
      margin: EdgeInsets.only(bottom: 20, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
            duration: duration300,
            opacity: stopwatch.wasReset ? 0 : 1.0,
            child: CustomButton(
              height: w * 0.15,
              width: w * 0.15,
              duration: duration200,
              color: bgColor,
              radius: 15,
              highlightColor: Colors.transparent,
              splashColor:
              stopwatch.wasReset ? Colors.transparent : Colors.red.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: whiteShadow,
                  blurRadius: 7,
                  offset: Offset(0, -2),
                ),
                BoxShadow(
                  color: blackShadow,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              onPressed: () {
                if (!stopwatch.wasReset) {
                  resetStopwatch(context);
                }
              },
              child: Icon(
                LineAwesomeIcons.stop,
                color: primaryTextColor,
              ),
            ),
          ),
          AnimatedContainer(
            height: 30,
            curve: fastOutSlowIn,
            width:  stopwatch.wasReset ? 0 : 30, duration: duration400,
          ),
          CustomButton(
            color: bgColor,
            splashColor: whiteShadow,
            highlightColor: Colors.transparent,
            height: w * 0.15,
            width: w * 0.15,
            duration: duration200,
            radius: 15,
            boxShadow: [
              BoxShadow(
                color: whiteShadow,
                blurRadius: 7,
                offset: Offset(0, -2),
              ),
              BoxShadow(
                color: blackShadow,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            onPressed: () {
              startStopwatch(context);
            },
            child: Icon(
              stopwatch.isTimerRunning
                  ? LineAwesomeIcons.pause
                  : LineAwesomeIcons.play,
              color: primaryTextColor,
            ),
          ),
          AnimatedContainer(
            height: 30,
            curve: fastOutSlowIn,
            width: stopwatch.wasReset ? 0 : 30, duration: duration400,
          ),
          AnimatedOpacity(
            duration: duration300,
            opacity: stopwatch.wasReset ? 0 : 1.0,
            child: CustomButton(
              height: w * 0.15,
              width: w * 0.15,
              duration: duration200,
              color: bgColor,
              radius: 15,
              highlightColor: Colors.transparent,
              splashColor: whiteShadow,
              boxShadow: [
                BoxShadow(
                  color: whiteShadow,
                  blurRadius: 7,
                  offset: Offset(0, -2),
                ),
                BoxShadow(
                  color: blackShadow,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              onPressed: () {
                if (!stopwatch.wasReset) addLap(context);
              },
              child: Icon(
                LineAwesomeIcons.hourglass,
                color: primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void startStopwatch(BuildContext context) {

  final StopWatch stopwatch = Provider.of<StopWatch>(context, listen: false);
  if (stopwatch.isTimerRunning){
    stopwatch.stop();
    Wakelock.disable();
  } else{
    stopwatch.start();
    Wakelock.enable();
  }

}

BuildContext get getContext => _context;

void resetStopwatch(BuildContext context) {

  Provider.of<StopWatch>(context, listen: false).reset();
  Wakelock.disable();
  resetLaps(context);

}

addLap(BuildContext context) {
  Laps laps = Provider.of<Laps>(context, listen: false);
  StopWatch stopWatch = Provider.of<StopWatch>(context, listen: false);
  laps.addLap(stopWatch.hours, stopWatch.minutes, stopWatch.seconds,
      stopWatch.milliseconds);
  Future.delayed(duration200, () {
    lapsController.animateTo(lapsController.position.maxScrollExtent,
        duration: duration200, curve: fastOutSlowIn);
  });
}

resetLaps(BuildContext context) {
  Provider.of<Laps>(context, listen: false).resetLaps();
}