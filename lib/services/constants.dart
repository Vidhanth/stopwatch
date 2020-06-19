import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

//Colors
Color bgColor = Color(0xff15181b);
Color whiteShadow = Colors.white.withOpacity(0.07);
Color blackShadow = Colors.black.withOpacity(0.45);
Color primaryTextColor = Colors.grey[400];


AssetsAudioPlayer intervalAudio = AssetsAudioPlayer();
AssetsAudioPlayer specificAudio = AssetsAudioPlayer();


//Keys
final String playSoundKey = "psk";
final String specificPlaySoundKey = "spsk";
final String autoLapKey = "alk";
final String stopClockKey = "sck";
final String intervalActionsKey = "iak";
final String specificActionsKey = "sak";
final String speakTimeKey = "sptk";
final String specificAutoLapKey = "salk";
final String intervalToneKey = "it";
final String specificToneKey = "st";
final String intervalTimeKey = "itk";
final String specificTimeKey = "stk";

//Durations
const Duration duration100 = Duration(milliseconds: 100);
const Duration duration200 = Duration(milliseconds: 200);
const Duration duration300 = Duration(milliseconds: 300);
const Duration duration400 = Duration(milliseconds: 400);
const Duration duration500 = Duration(milliseconds: 500);
const Duration duration600 = Duration(milliseconds: 600);
const Duration duration700 = Duration(milliseconds: 700);
const Duration duration800 = Duration(milliseconds: 800);

//Controllers
ScrollController lapsController = ScrollController();

//Other Constants
final int maxTones = 6;

//Curves
const Curve fastOutSlowIn = Curves.fastOutSlowIn;

//Screen Ratio
final int normalRatio = 16 ~/ 9;

//Fonts
const _poppins = 'Poppins';

const TextStyle poppinsRegular = TextStyle(
  fontFamily: _poppins,
  fontWeight: FontWeight.w400,
);

const TextStyle poppinsMedium = TextStyle(
  fontFamily: _poppins,
  fontWeight: FontWeight.w600,
);

const TextStyle poppinsLight = TextStyle(
  fontFamily: _poppins,
  fontWeight: FontWeight.w300,
);

const TextStyle poppinsBold = TextStyle(
  fontFamily: _poppins,
  fontWeight: FontWeight.w700,
);


void playSounds(AssetsAudioPlayer audio,) {
  audio.play();
}

double getPlayBackSpeed(int tone, int interval) {
  if (tone == 5 || tone == 3)
    return 1;
  else {
    if (interval <= 2) {
      return 2;
    } else
      return 1;
  }
}