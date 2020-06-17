import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/components/laps_list.dart';
import 'package:stopwatch/models/show_settings.dart';
import 'package:stopwatch/services/constants.dart';
import 'package:stopwatch/services/custom_buttons.dart';
import 'package:stopwatch/services/poppins_text.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: w * 0.15,
            child: PoppinsBold(
              text: "Stopwatch",
              textSize: 130,
              textAlign: TextAlign.start,
              textColor: primaryTextColor,
            ),
          ),
          CustomButton(
            height: w * 0.15,
            width: w * 0.15,
            duration: duration200,
            color: bgColor,
            radius: 30,
            highlightColor: Colors.transparent,
            splashColor: Colors.white10,
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
              toggleSettings(context);
            },
            child: Icon(
              LineAwesomeIcons.cog,
              color: primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

void toggleSettings(BuildContext context) {
  ShowSettings settings = Provider.of<ShowSettings>(context, listen: false);
  settings.showSettings = !settings.showSettings;
  if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool intervalActions = false;
  bool playSound = false;
  bool autoLap = false;
  bool specificActions = false;
  bool specificPlaySound = false;
  bool specificStopClock= false;
  bool specificAutoLap = false;
  bool specificSoundSettings = false;
  bool soundSettings = false;
  Color activeTextColor = Colors.black.withOpacity(0.75);
  Color inactiveTextColor = Colors.black.withOpacity(0.45);

  togglePlaySound() {
    setState(() {
      playSound = !playSound;
    });
  }

  toggleSoundSettings() {
    setState(() {
      soundSettings = !soundSettings;
    });
  }

  toggleIntervalActions() {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
    setState(() {
      intervalActions = !intervalActions;
    });
  }

  toggleAutoLap() {
    setState(() {
      autoLap = !autoLap;
    });
  }

  toggleSpecificActions(){
    setState(() {
      specificActions = !specificActions;
    });
  }

  toggleSpecificPlaySound(){
    setState(() {
      specificPlaySound = !specificPlaySound;
    });
  }

  toggleSpecificStopClock(){
    setState(() {
      specificStopClock = !specificStopClock;
    });
  }

  toggleSpecificSoundSettings() {
    setState(() {
      specificSoundSettings = !specificSoundSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: w,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, -20),
            blurRadius: 50,
          )
        ],
        color: Colors.grey[500],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50,
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PoppinsBold(
                  text: "Settings",
                  textColor: activeTextColor,
                  textSize: 120,
                ),
                GestureDetector(
                  onTap: () {
                    toggleSettings(context);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: activeTextColor,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              toggleIntervalActions();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedDefaultTextStyle(
                  child: Container(
                    height: 25,
                    child: AutoSizeText(
                      "Interval Actions",
                    ),
                  ),
                  style: poppinsMedium.copyWith(
                    fontSize: 120,
                    color:
                        intervalActions ? activeTextColor : inactiveTextColor,
                  ),
                  duration: duration500,
                ),
                Switch(
                  onChanged: (play) {
                    toggleIntervalActions();
                  },
                  value: intervalActions,
                  activeColor: Colors.black,
                )
              ],
            ),
          ),
          IgnorePointer(
            ignoring: !intervalActions,
            child: AnimatedOpacity(
              opacity: intervalActions ? 1.0 : 0.5,
              duration: duration500,
              child: Column(
                children: <Widget>[
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 70,
                              width: 80,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CustomRangeTextInputFormatter(),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                cursorColor: inactiveTextColor,
                                maxLength: 2,
                                scrollPhysics: BouncingScrollPhysics(),
                                cursorRadius: Radius.circular(10),
                                decoration: InputDecoration(
                                    hintText: "00",
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero),
                                style: poppinsBold.copyWith(
                                    fontSize: 50, color: activeTextColor),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: PoppinsMedium(
                                textColor: activeTextColor,
                                textSize: 120,
                                text: "hr",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 70,
                              width: 80,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CustomRangeTextInputFormatter(),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                cursorColor: inactiveTextColor,
                                maxLength: 2,
                                scrollPhysics: BouncingScrollPhysics(),
                                cursorRadius: Radius.circular(10),
                                decoration: InputDecoration(
                                    hintText: "00",
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero),
                                style: poppinsBold.copyWith(
                                    fontSize: 50, color: activeTextColor),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: PoppinsMedium(
                                textColor: activeTextColor,
                                textSize: 120,
                                text: "min",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 70,
                              width: 80,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CustomRangeTextInputFormatter(),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                cursorColor: inactiveTextColor,
                                maxLength: 2,
                                scrollPhysics: BouncingScrollPhysics(),
                                cursorRadius: Radius.circular(10),
                                decoration: InputDecoration(
                                    hintText: "00",
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero),
                                style: poppinsBold.copyWith(
                                    fontSize: 50, color: activeTextColor),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: PoppinsMedium(
                                textColor: activeTextColor,
                                textSize: 120,
                                text: "sec",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _toggleContainer(
                                "Auto lap", toggleAutoLap, autoLap),
                            SizedBox(
                              width: 10,
                            ),
                            _toggleContainer(
                                "Play sound", togglePlaySound, playSound),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomButton(
                          duration: duration500,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                LineAwesomeIcons.cog,
                                size: 20,
                                color: soundSettings
                                    ? Colors.grey[500]
                                    : activeTextColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 20,
                                child: PoppinsMedium(
                                  text: "More",
                                  textSize: 120,
                                  textColor: soundSettings
                                      ? Colors.grey[500]
                                      : activeTextColor,
                                ),
                              ),
                            ],
                          ),
                          hasShadow: false,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            toggleSoundSettings();
                          },
                          color: soundSettings
                              ? activeTextColor
                              : Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderWidth: 1,
                          hasBorder: soundSettings ? false : true,
                          borderColor: activeTextColor,
                          height: 38,
                          width: 75,
                        )
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    height: soundSettings ? 60 : 0,
                    width: w,
                    duration: duration500,
                    curve: fastOutSlowIn,
                    margin: EdgeInsets.only(
                      top: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(5)),
                      color: Colors.black38,
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              toggleSpecificActions();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedDefaultTextStyle(
                  child: Container(
                    height: 25,
                    child: AutoSizeText(
                      "Specific Time Actions",
                    ),
                  ),
                  style: poppinsMedium.copyWith(
                    fontSize: 120,
                    color:
                    specificActions ? activeTextColor : inactiveTextColor,
                  ),
                  duration: duration500,
                ),
                Switch(
                  onChanged: (play) {
                    toggleSpecificActions();
                  },
                  value: specificActions,
                  activeColor: Colors.black,
                )
              ],
            ),
          ),
          IgnorePointer(
            ignoring: !specificActions,
            child: AnimatedOpacity(
              opacity: specificActions ? 1.0 : 0.5,
              duration: duration500,
              child: Column(
                children: <Widget>[
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 70,
                              width: 80,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  CustomRangeTextInputFormatter(),
                                ],
                                cursorColor: inactiveTextColor,
                                maxLength: 2,
                                scrollPhysics: BouncingScrollPhysics(),
                                cursorRadius: Radius.circular(10),
                                decoration: InputDecoration(
                                    hintText: "00",
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero),
                                style: poppinsBold.copyWith(
                                    fontSize: 50, color: activeTextColor),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: PoppinsMedium(
                                textColor: activeTextColor,
                                textSize: 120,
                                text: "hr",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 70,
                              width: 80,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CustomRangeTextInputFormatter(),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                cursorColor: inactiveTextColor,
                                maxLength: 2,
                                scrollPhysics: BouncingScrollPhysics(),
                                cursorRadius: Radius.circular(10),
                                decoration: InputDecoration(
                                    hintText: "00",
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero),
                                style: poppinsBold.copyWith(
                                    fontSize: 50, color: activeTextColor),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: PoppinsMedium(
                                textColor: activeTextColor,
                                textSize: 120,
                                text: "min",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 70,
                              width: 80,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CustomRangeTextInputFormatter(),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                cursorColor: inactiveTextColor,
                                maxLength: 2,
                                scrollPhysics: BouncingScrollPhysics(),
                                cursorRadius: Radius.circular(10),
                                decoration: InputDecoration(
                                    hintText: "00",
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero),
                                style: poppinsBold.copyWith(
                                    fontSize: 50, color: activeTextColor),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: PoppinsMedium(
                                textColor: activeTextColor,
                                textSize: 120,
                                text: "sec",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _toggleContainer(
                                "Stop timer", toggleSpecificStopClock, specificStopClock),
                            SizedBox(
                              width: 10,
                            ),
                            _toggleContainer(
                                "Play sound", toggleSpecificPlaySound, specificPlaySound),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomButton(
                          duration: duration500,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                LineAwesomeIcons.cog,
                                size: 20,
                                color: specificSoundSettings
                                    ? Colors.grey[500]
                                    : activeTextColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 20,
                                child: PoppinsMedium(
                                  text: "More",
                                  textSize: 120,
                                  textColor: specificSoundSettings
                                      ? Colors.grey[500]
                                      : activeTextColor,
                                ),
                              ),
                            ],
                          ),
                          hasShadow: false,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            toggleSpecificSoundSettings();
                          },
                          color: specificSoundSettings
                              ? activeTextColor
                              : Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderWidth: 1,
                          hasBorder: specificSoundSettings ? false : true,
                          borderColor: activeTextColor,
                          height: 38,
                          width: 75,
                        )
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    height: specificSoundSettings ? 60 : 0,
                    width: w,
                    duration: duration500,
                    curve: fastOutSlowIn,
                    margin: EdgeInsets.only(
                      top: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(5)),
                      color: Colors.black38,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleContainer(String name, Function onPressed, bool selected) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: AnimatedContainer(
        height: 40,
        width: 130,
        alignment: Alignment.center,
        duration: duration400,
        curve: fastOutSlowIn,
        decoration: BoxDecoration(
          color: selected ? Colors.transparent : activeTextColor,
          borderRadius: BorderRadius.circular(200),
          border: Border.all(
              color: selected ? activeTextColor : Colors.transparent),
        ),
        child: FittedBox(
          child: AnimatedDefaultTextStyle(
            duration: duration500,
            child: Text(name),
            style: poppinsMedium.copyWith(
              color: !selected ? Colors.white60 : activeTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue,) {
    if(newValue.text == '')
      return TextEditingValue();
    else if(int.parse(newValue.text) < 0)
      return TextEditingValue().copyWith(text: '00');

    return int.parse(newValue.text) > 59 ? TextEditingValue().copyWith(text: '59') : newValue;
  }
}