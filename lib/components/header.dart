import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
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
bool initialized = false;
List<String> intervalTime = ["00", "00", "00"];
List<String> specificTime = ["00", "00", "00"];
TextEditingController _intControllerHour;
TextEditingController _intControllerMin;
TextEditingController _intControllerSec;
TextEditingController _speControllerHour;
TextEditingController _speControllerMin;
TextEditingController _speControllerSec;
bool intervalActions = false;
bool playSound = false;
bool autoLap = false;
bool specificActions = false;
bool specificPlaySound = false;
bool specificStopClock = false;
bool specificAutoLap = false;
bool speakTime = false;
bool specificSoundSettings = false;
bool soundSettings = false;
int intervalTone = 0;
int specificTone = 0;

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
          GestureDetector(
            onTap: () {
              toggleSettings(context);
            },
            child: Container(
              height: w * 0.15,
              child: PoppinsBold(
                text: "Stopwatch",
                textSize: 130,
                textAlign: TextAlign.start,
                textColor: primaryTextColor,
              ),
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
  if (!initialized) initializePrefs();
  ShowSettings settings = Provider.of<ShowSettings>(context, listen: false);
  if (settings.showSettings) {
    saveIntervalTime(intervalTime);
    saveSpecificTime(specificTime);
  }
  if (specificSoundSettings) specificSoundSettings = false;
  if (soundSettings) soundSettings = false;

  if(noIntervalActions()){
    intervalActions = false;
  }

  if(noSpecificActions()){
    specificActions = false;
  }

  settings.showSettings = !settings.showSettings;
  if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
}

bool noSpecificActions() {
  return (!speakTime && !specificPlaySound && !specificAutoLap && !specificStopClock );
}

bool noIntervalActions() {
  return (!autoLap && !playSound);
}

void initializePrefs() async {
  _prefs = await SharedPreferences.getInstance();
  print("Initializing Preferences");
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
  speakTime = _prefs.getBool(speakTimeKey);
  _intControllerHour = TextEditingController(text: getText(intervalTime[0]));
  _intControllerMin = TextEditingController(text: getText(intervalTime[1]));
  _intControllerSec = TextEditingController(text: getText(intervalTime[2]));
  _speControllerHour = TextEditingController(text: getText(specificTime[0]));
  _speControllerMin = TextEditingController(text: getText(specificTime[1]));
  _speControllerSec = TextEditingController(text: getText(specificTime[2]));
  initialized = true;
}

String getText(String text) {
  if(int.parse(text)==0)
    return "";
  return text;
}

saveIntervalTime(List<String> newTime) async {
  setTime();
  if (intervalTime.toString() == "[00, 00, 00]") {
    intervalActions = false;
    await _prefs.setBool(intervalActionsKey, intervalActions);
  }
  if (specificTime.toString() == "[00, 00, 00]") {
    specificActions = false;
    await _prefs.setBool(specificActionsKey, specificActions);
  }
  await _prefs.setStringList(intervalTimeKey, newTime);
}

saveSpecificTime(List<String> newTime) async {
  setTime();
  print(specificTime);
  if (intervalTime.toString() == "[00, 00, 00]") {
    intervalActions = false;
    await _prefs.setBool(intervalActionsKey, intervalActions);
  }
  if (specificTime.toString() == "[00, 00, 00]") {
    specificActions = false;
    await _prefs.setBool(specificActionsKey, specificActions);
  }
  await _prefs.setStringList(specificTimeKey, newTime);
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color activeTextColor = Colors.black.withOpacity(0.75);
  Color inactiveTextColor = Colors.black.withOpacity(0.45);

  togglePlaySound() async {
    setState(() {
      playSound = !playSound;
      if (soundSettings) soundSettings = false;
    });
    await _prefs.setBool(playSoundKey, playSound);
  }

  toggleSoundSettings() {
    setState(() {
      soundSettings = !soundSettings;
    });
  }

  toggleIntervalActions() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      setTime();
    }
    setState(() {
      intervalActions = !intervalActions;
      if (soundSettings) soundSettings = false;
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
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      setTime();
    }
    setState(() {
      specificActions = !specificActions;
      if (specificSoundSettings) specificSoundSettings = false;
    });
    await _prefs.setBool(specificActionsKey, specificActions);
  }

  toggleSpecificPlaySound() async {
    setState(() {
      if (speakTime) toggleSpeakTime();
      specificPlaySound = !specificPlaySound;
      if (specificSoundSettings) specificSoundSettings = !specificSoundSettings;
    });
    await _prefs.setBool(specificPlaySoundKey, specificPlaySound);
  }

  toggleSpecificStopClock() async {
    setState(() {
      specificStopClock = !specificStopClock;
    });
    await _prefs.setBool(stopClockKey, specificStopClock);
  }

  toggleSpeakTime() async {
    setState(() {
      if (specificPlaySound) toggleSpecificPlaySound();
      speakTime = !speakTime;
    });
    await _prefs.setBool(speakTimeKey, speakTime);
  }

  toggleSpecificSoundSettings() {
    setState(() {
      specificSoundSettings = !specificSoundSettings;
    });
  }

  toggleSpecificAutoLap() async {
    setState(() {
      specificAutoLap = !specificAutoLap;
    });
    await _prefs.setBool(specificAutoLapKey, specificAutoLap);
  }

  setIntervalTone(int tone) async {
    setState(() {
      intervalTone = tone;
    });
    intervalAudio.open(Audio("assets/audios/tone$tone.mp3"),
        playSpeed: getPlayBackSpeed(tone, 10));
    playSounds(intervalAudio);
    await _prefs.setInt(intervalToneKey, intervalTone);
  }

  setSpecificTone(int tone) async {
    setState(() {
      specificTone = tone;
    });
    specificAudio.open(Audio("assets/audios/tone$tone.mp3"),
        playSpeed: getPlayBackSpeed(tone, 10));
    playSounds(specificAudio);
    await _prefs.setInt(specificToneKey, specificTone);
  }

  @override
  void dispose() {
    _speControllerSec.dispose();
    _speControllerMin.dispose();
    _speControllerHour.dispose();
    _intControllerHour.dispose();
    _intControllerMin.dispose();
    _intControllerSec.dispose();
    super.dispose();
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
            height: 55,
            margin: EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                toggleSettings(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PoppinsBold(
                    text: "Settings",
                    textColor: activeTextColor,
                    textSize: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: activeTextColor,
                      size: 40,
                    ),
                  )
                ],
              ),
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
                    height: 30,
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
                  Container(
                    width: w,
                    child: FittedBox(
                      child: Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 70,
                                width: 80,
                                alignment: Alignment.centerRight,
                                child: TextFormField(
                                  controller: _intControllerHour,
                                  keyboardType: TextInputType.number,
                                  onTap: () {
                                    handleOnTap(_intControllerHour);
                                  },
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
                                      fontSize: 45, color: activeTextColor),
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
                                  onTap: () {
                                    handleOnTap(_intControllerMin);
                                  },
                                  scrollPhysics: BouncingScrollPhysics(),
                                  cursorRadius: Radius.circular(10),
                                  decoration: InputDecoration(
                                      hintText: "00",
                                      counterText: "",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero),
                                  style: poppinsBold.copyWith(
                                      fontSize: 45, color: activeTextColor),
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
                                  onTap: () {
                                    handleOnTap(_intControllerSec);
                                  },
                                  decoration: InputDecoration(
                                      hintText: "00",
                                      counterText: "",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero),
                                  style: poppinsBold.copyWith(
                                      fontSize: 45, color: activeTextColor),
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
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: w,
                    child: FittedBox(
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
                            disabled: !playSound,
                            margin: EdgeInsets.only(right: 00),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  LineAwesomeIcons.cog,
                                  size: 20,
                                  color: soundSettings
                                      ? Colors.grey[500]
                                      : activeTextColor,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
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
                            height: 40,
                            width: 75,
                          )
                        ],
                      ),
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
                                  maxTones,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(
                                            left: 13.0,
                                            right:
                                                index == maxTones - 1 ? 13 : 0),
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
                    height: 30,
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
                  Container(
                    width: w,
                    child: FittedBox(
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
                                  onTap: () {
                                    handleOnTap(_speControllerHour);
                                  },
                                  scrollPhysics: BouncingScrollPhysics(),
                                  cursorRadius: Radius.circular(10),
                                  decoration: InputDecoration(
                                      hintText: "00",
                                      counterText: "",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero),
                                  style: poppinsBold.copyWith(
                                      fontSize: 45, color: activeTextColor),
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
                                  onTap: () {
                                    handleOnTap(_speControllerMin);
                                  },
                                  cursorRadius: Radius.circular(10),
                                  decoration: InputDecoration(
                                      hintText: "00",
                                      counterText: "",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero),
                                  style: poppinsBold.copyWith(
                                      fontSize: 45, color: activeTextColor),
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
                                  onTap: () {
                                    handleOnTap(_speControllerSec);
                                  },
                                  scrollPhysics: BouncingScrollPhysics(),
                                  cursorRadius: Radius.circular(10),
                                  decoration: InputDecoration(
                                      hintText: "00",
                                      counterText: "",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero),
                                  style: poppinsBold.copyWith(
                                      fontSize: 45, color: activeTextColor),
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
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: w,
                    child: FittedBox(
                      child: Row(
                        children: <Widget>[
                          _toggleContainer(
                              "Speak time", toggleSpeakTime, speakTime),
                          SizedBox(
                            width: 10,
                          ),
                          _toggleContainer("Play sound",
                              toggleSpecificPlaySound, specificPlaySound),
                          SizedBox(
                            width: 10,
                          ),
                          CustomButton(
                            disabled: !specificPlaySound,
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
                            height: 40,
                            width: 75,
                          )
                        ],
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: specificSoundSettings ? 1.0 : 0.0,
                    duration: duration600,
                    curve: fastOutSlowIn,
                    child: AnimatedPadding(
                      padding: EdgeInsets.symmetric(
                          vertical: specificSoundSettings ? 15 : 5),
                      duration: duration700,
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
                                topRight: Radius.circular(1)),
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
                                    maxTones,
                                    (index) => Padding(
                                          padding: EdgeInsets.only(
                                              left: 13.0,
                                              right: index == maxTones - 1
                                                  ? 13
                                                  : 0),
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
                    ),
                  ),
                  Container(
                    width: w,
                    child: FittedBox(
                      child: Row(
                        children: <Widget>[
                          _toggleContainer("Lap time", toggleSpecificAutoLap,
                              specificAutoLap),
                          SizedBox(
                            width: 10,
                          ),
                          _toggleContainer("Stop timer",
                              toggleSpecificStopClock, specificStopClock),
                          SizedBox(
                            width: 10,
                          ),
                          _toggleContainer(" ", () {}, false),
                        ],
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
        if(FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
          setTime();
        }
        onPressed();
      },
      child: AnimatedContainer(
        height: name.trim().isEmpty ? 0 : 40,
        width: name.trim().isEmpty ? 75 : 130,
        alignment: Alignment.center,
        padding: EdgeInsets.all(7),
        duration: duration400,
        curve: fastOutSlowIn,
        decoration: BoxDecoration(
          color: !selected ? Colors.transparent : activeTextColor,
          borderRadius: BorderRadius.circular(200),
          border: Border.all(
            color: !selected ? activeTextColor : Colors.transparent,
          ),
        ),
        child: FittedBox(
          child: PoppinsMedium(
            text: name,
            textSize: 120,
            textColor: selected ? Colors.grey[500] : activeTextColor,
          ),
        ),
      ),
    );
  }
}

void handleOnTap(TextEditingController controller) {
  setTime();
  if (controller.text.isNotEmpty) {
    if (controller.text == "00")
      controller.clear();
    else if (int.parse(controller.text) < 10) {
      controller.text = controller.text.replaceAll("0", "");
    }
  }
}

setTime(){
  _intControllerHour.text = getText(intervalTime[0]);
  _intControllerMin.text = getText(intervalTime[1]);
  _intControllerSec.text = getText(intervalTime[2]);
  _speControllerHour.text = getText(specificTime[0]);
  _speControllerMin.text = getText(specificTime[1]);
  _speControllerSec.text = getText(specificTime[2]);
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
