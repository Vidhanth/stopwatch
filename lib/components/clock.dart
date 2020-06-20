import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:stopwatch/models/stopwatch.dart';
import 'package:stopwatch/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/services/poppins_text.dart';

class Clock extends StatelessWidget {
  final Offset whiteOffset = Offset(-0, -10);
  final Offset blackOffset = Offset(0, 10);
  final double clockTextSize = 70;
  double w;

  @override
  Widget build(BuildContext context) {
    if (w == null) w = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                    border: Border.all(color: Colors.black.withOpacity(0.5), width: 5),
                  ),
                  height: w * 0.7,
                  width: w * 0.7,
                  padding: EdgeInsets.all(15),
                  child: FittedBox(
                    child: Consumer<StopWatch>(
                      builder: (context, stopwatch, _) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: stopwatch.hours == 0 ? 0 : clockTextSize,
                            height: stopwatch.hours == 0 ? 0 : clockTextSize,
                            child: PoppinsBold(
                              text: stopwatch.hours < 10
                                  ? "0${stopwatch.hours}"
                                  : stopwatch.hours.toString(),
                              textColor: primaryTextColor,
                              textSize: 120,
                            ),
                          ),
                          Container(
                            height: stopwatch.hours == 0 ? 0 : 45,
                            child: PoppinsRegular(
                              text: " : ",
                              textSize: 120,
                              textColor: primaryTextColor,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: clockTextSize,
                            height: clockTextSize,
                            child: PoppinsBold(
                              text: stopwatch.minutes < 10
                                  ? "0${stopwatch.minutes}"
                                  : stopwatch.minutes.toString(),
                              textColor: primaryTextColor,
                              textSize: 120,
                            ),
                          ),
                          Container(
                            height: 45,
                            child: PoppinsRegular(
                              text: " : ",
                              textSize: 120,
                              textColor: primaryTextColor,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: clockTextSize,
                            height: clockTextSize,
                            child: PoppinsBold(
                              text: stopwatch.seconds < 10
                                  ? "0${stopwatch.seconds}"
                                  : stopwatch.seconds.toString(),
                              textColor: primaryTextColor,
                              textSize: 120,
                            ),
                          ),
                          Container(
                            height: 45,
                            child: PoppinsMedium(
                              text: " : ",
                              textSize: 120,
                              textColor: primaryTextColor,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: clockTextSize,
                            height: clockTextSize,
                            child: PoppinsBold(
                              text: stopwatch.milliseconds < 10
                                  ? "0${stopwatch.milliseconds}"
                                  : stopwatch.milliseconds.toString(),
                              textColor: primaryTextColor,
                              textSize: 120,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
