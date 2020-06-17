import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch/components/laps_list.dart';
import 'package:stopwatch/models/show_settings.dart';
import 'package:stopwatch/services/constants.dart';
import 'package:stopwatch/services/custom_buttons.dart';
import 'package:stopwatch/services/poppins_text.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

SharedPreferences _prefs;
List<String> intervalTime = ["00", "00", "00"];
List<String> specificTime = ["00", "00", "00"];
TextEditingController _intControllerHour;
TextEditingController _intControllerMin;
TextEditingController _intControllerSec;
TextEditingController _speControllerHour;
TextEditingController _speControllerMin;
TextEditingController _speControllerSec;

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
  if (settings.showSettings) {
    saveIntervalTime(intervalTime);
    saveSpecificTime(specificTime);
  }
  settings.showSettings = !settings.showSettings;
  if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
}

saveIntervalTime(List<String> newTime) async {
  _intControllerHour.text = intervalTime[0];
  _intControllerMin.text = intervalTime[1];
  _intControllerSec.text = intervalTime[2];
  print(intervalTime);
  await _prefs.setStringList(intervalTimeKey, newTime);
}

saveSpecificTime(List<String> newTime) async {
  _speControllerHour.text = specificTime[0];
  _speControllerMin.text = specificTime[1];
  _speControllerSec.text = specificTime[2];
  print(specificTime);
  await _prefs.setStringList(specificTimeKey, newTime);
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
  bool specificStopClock = false;
  bool specificAutoLap = false;
  bool specificSoundSettings = false;
  bool soundSettings = false;
  int intervalTone = 0;
  int specificTone = 0;
  Color activeTextColor = Colors.black.withOpacity(0.75);
  Color inactiveTextColor = Colors.black.withOpacity(0.45);

  togglePlaySound() async {
    setState(() {
      playSound = !playSound;
    });
    await _prefs.setBool(playSoundKey, playSound);
  }

  toggleSoundSettings() {
    setState(() {
      soundSettings = !soundSettings;
    });
  }

  toggleIntervalActions() async {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
    setState(() {
      intervalActions = !intervalActions;
    });
    await _prefs.setBool(intervalActionsKey, intervalActions);
  }

  toggleAutoLap() async {
    setState(() {
      autoLap = !autoLap;
    });
    await _prefs.setBool(autoLapKey, autoLap);
  }

  toggleSpecificActions() async {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
    setState(() {
      specificActions = !specificActions;
    });
    await _prefs.setBool(specificActionsKey, specificActions);
  }

  toggleSpecificPlaySound() async {
    setState(() {
      specificPlaySound = !specificPlaySound;
    });
    await _prefs.setBool(specificPlaySoundKey, specificPlaySound);
  }

  toggleSpecificStopClock() async {
    setState(() {
      specificStopClock = !specificStopClock;
    });
    await _prefs.setBool(stopClockKey, specificStopClock);
  }

  toggleSpecificSoundSettings() {
    setState(() {
      specificSoundSettings = !specificSoundSettings;
    });
  }

  setIntervalTone(int tone) async {
    setState(() {
      intervalTone = tone;
    });
    await _prefs.setInt(intervalToneKey, intervalTone);
  }

  setSpecificTone(int tone) async {
    setState(() {
      specificTone = tone;
    });
    await _prefs.setInt(intervalToneKey, specificTone);
  }

  @override
  void initState() {
    Future.delayed(duration200, (){
      initializePrefs();
    });
    super.initState();
  }

  void initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    intervalActions = _prefs.getBool(intervalActionsKey);
    specificActions = _prefs.getBool(specificActionsKey);
    specificTime = _prefs.getStringList(specificTimeKey);
    intervalTime = _prefs.getStringList(intervalTimeKey);
    print(intervalTime);
    intervalTone = _prefs.getInt(intervalToneKey);
    specificTone = _prefs.getInt(specificToneKey);
    playSound = _prefs.getBool(playSoundKey);
    specificPlaySound = _prefs.getBool(specificPlaySoundKey);
    autoLap = _prefs.getBool(autoLapKey);
    specificStopClock = _prefs.getBool(stopClockKey);
    _intControllerHour = TextEditingController(text: intervalTime[0]);
    _intControllerMin = TextEditingController(text: intervalTime[1]);
    _intControllerSec = TextEditingController(text: intervalTime[2]);
    _speControllerHour = TextEditingController(text: specificTime[0]);
    _speControllerMin = TextEditingController(text: specificTime[1]);
    _speControllerSec = TextEditingController(text: specificTime[2]);
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
                crossAxisAlignment: CrossAxisAlignment.end,
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
                              child: TextFormField(
                                controller: _intControllerHour,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CustomRangeTextInputFormatter(),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                onFieldSubmitted: (String hour) {
                                  saveIntervalTime(intervalTime);
                                },
                                onChanged: (String hour) {
                                  intervalTime[0] = getFormattedText(hour);
                                },
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
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CustomRangeTextInputFormatter(),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                controller: _intControllerMin,
                                cursorColor: inactiveTextColor,
                                onFieldSubmitted: (String min) {
                                  saveIntervalTime(intervalTime);
                                },
                                onChanged: (String min) {
                                  intervalTime[1] = getFormattedText(min);
                                },
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
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CustomRangeTextInputFormatter(),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                cursorColor: inactiveTextColor,
                                maxLength: 2,
                                scrollPhysics: BouncingScrollPhysics(),
                                cursorRadius: Radius.circular(10),
                                controller: _intControllerSec,
                                onFieldSubmitted: (String sec) {
                                  saveIntervalTime(intervalTime);
                                },
                                onChanged: (String sec) {
                                  intervalTime[2] = getFormattedText(sec);
                                },
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
                  SizedBox(
                    height: 15,
                  ),
                  AnimatedOpacity(
                    opacity: soundSettings ? 1.0 : 0.0,
                    duration: duration600,
                    curve: fastOutSlowIn,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(1)),
                      child: AnimatedContainer(
                        height: soundSettings ? 60 : 0,
                        width: soundSettings ? w : 0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(1),
                        duration: duration700,
                        curve: Curves.ease,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              topRight: Radius.circular(0)),
                          color: Colors.black38,
                        ),
                        child: AnimatedOpacity(
                          opacity: soundSettings ? 1.0 : 0.0,
                          duration: duration200,
                          curve: fastOutSlowIn,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  7,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(
                                            left: 13.0,
                                            right: index == 6 ? 13 : 0),
                                        child: _toggleContainer(
                                            "Tone ${index + 1}", () {
                                          setIntervalTone(index);
                                        }, intervalTone == index),
                                      )),
                            ),
                          ),
                        ),
                      ),
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
                crossAxisAlignment: CrossAxisAlignment.end,
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
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _speControllerHour,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  CustomRangeTextInputFormatter(),
                                ],
                                onFieldSubmitted: (String hour) {
                                  saveSpecificTime(specificTime);
                                },
                                onChanged: (String hour) {
                                  specificTime[0] = getFormattedText(hour);
                                },
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
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _speControllerMin,
                                onFieldSubmitted: (String min) {
                                  saveSpecificTime(specificTime);
                                },
                                onChanged: (String min) {
                                  specificTime[1] = getFormattedText(min);
                                },
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
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _speControllerSec,
                                onFieldSubmitted: (String sec) {
                                  saveSpecificTime(specificTime);
                                },
                                onChanged: (String sec) {
                                  specificTime[2] = getFormattedText(sec);
                                },
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
                            _toggleContainer("Stop timer",
                                toggleSpecificStopClock, specificStopClock),
                            SizedBox(
                              width: 10,
                            ),
                            _toggleContainer("Play sound",
                                toggleSpecificPlaySound, specificPlaySound),
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
                  SizedBox(
                    height: 15,
                  ),
                  AnimatedOpacity(
                    opacity: specificSoundSettings ? 1.0 : 0.0,
                    duration: duration600,
                    curve: fastOutSlowIn,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(1)),
                      child: AnimatedContainer(
                        height: specificSoundSettings ? 60 : 0,
                        width: specificSoundSettings ? w : 0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(1),
                        duration: duration700,
                        curve: Curves.ease,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              topRight: Radius.circular(0)),
                          color: Colors.black38,
                        ),
                        child: AnimatedOpacity(
                          opacity: specificSoundSettings ? 1.0 : 0.0,
                          duration: duration200,
                          curve: fastOutSlowIn,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  7,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(
                                            left: 13.0,
                                            right: index == 6 ? 13 : 0),
                                        child: _toggleContainer(
                                            "Tone ${index + 1}", () {
                                          setSpecificTone(index);
                                        }, specificTone == index),
                                      )),
                            ),
                          ),
                        ),
                      ),
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
          color: !selected ? Colors.transparent : activeTextColor,
          borderRadius: BorderRadius.circular(200),
          border: Border.all(
              color: !selected ? activeTextColor : Colors.transparent),
        ),
        child: FittedBox(
          child: AnimatedDefaultTextStyle(
            duration: duration300,
            child: Text(name),
            style: poppinsMedium.copyWith(
              color: selected ? Colors.white60 : activeTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

String getFormattedText(String text) {
  if (text.isEmpty)
    text = "00";
  else {
    if (int.parse(text) < 10 && text.length < 2) {
      text = "0$text";
    }
  }
  return text;
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '')
      return TextEditingValue();
    else if (int.parse(newValue.text) < 0)
      return TextEditingValue().copyWith(text: '00');

    return int.parse(newValue.text) > 59
        ? TextEditingValue().copyWith(text: '59')
        : newValue;
  }
}
