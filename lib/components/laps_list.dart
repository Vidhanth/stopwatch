import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/services/poppins_text.dart';
import 'package:stopwatch/services/constants.dart';
import 'package:stopwatch/services/zoom_in.dart';
import 'package:stopwatch/models/laps.dart';



int screenRatio;
double h;
double w;

class LapsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Laps laps = Provider.of<Laps>(context);
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    screenRatio = h ~/ w ;

    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: duration700,
          curve: fastOutSlowIn,
          height: 4,
          width: laps.lapsList.isEmpty ? 0 : w,
          decoration: BoxDecoration(
              color: Color(0xff0e1113),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  offset: Offset(0, 1),
                  color: Colors.white10,
                )
              ]),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 5, bottom: 20),
            controller: lapsController,
            itemCount: laps.lapsList.length,
            itemBuilder: (context, index) {
              return LapsListItem(index, laps);
            },
          ),
        ),
      ],
    );
  }
}

class LapsListItem extends StatelessWidget {
  final int index;
  final Laps laps;

  LapsListItem(this.index, this.laps);

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      duration: duration400,
      child: Container(
        height: screenRatio != normalRatio ? h * 0.1 : h * 0.12,
        width: w,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: whiteShadow,
                blurRadius: 10,
                offset: Offset(-0, -5),
              ),
              BoxShadow(
                color: blackShadow,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    width: index+1 < 10 ? 30 : (index+1).toString().length*15.toDouble(),
                    child: PoppinsBold(
                      text: (index + 1).toString(),
                      textColor: primaryTextColor,
                      textSize: 120,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 30,
                      child: PoppinsRegular(
                        text: "Lap",
                        textSize: 120,
                        textColor: primaryTextColor,
                      )),
                ],
              ),
              Container(
                height: 20,
                child: PoppinsBold(
                  text: laps.lapsList[index],
                  textColor: primaryTextColor,
                  textSize: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


