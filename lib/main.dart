import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch/models/show_settings.dart';
import 'components/stopwatch_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/services/constants.dart';
import 'components/laps_list.dart';
import 'package:stopwatch/models/stopwatch.dart';
import 'package:stopwatch/models/laps.dart';
import 'components/header.dart';
import 'components/clock.dart';

void main() {
  runApp(MyApp());
}

double h = 0;
double w = 0;
int screenRatio = 16 ~/ 9;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    initializePrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StopWatch>(
          create: (_) => StopWatch(),
        ),
        ChangeNotifierProvider<ShowSettings>(
          create: (BuildContext context) => ShowSettings(),
        ),
        ChangeNotifierProvider<Laps>(
          create: (_) => Laps(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          canvasColor: bgColor,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: bgColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBody: true,
          backgroundColor: bgColor,
          body: Home(),
        ),
      ),
    );
  }

  void initializePrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(_prefs.getBool(intervalActionsKey)==null)
      await _prefs.setBool(intervalActionsKey, false);

    if(_prefs.getBool(specificActionsKey)==null)
      await _prefs.setBool(specificActionsKey, false);

    if(_prefs.getStringList(intervalTimeKey)==null)
      await _prefs.setStringList(intervalTimeKey, ["00","00","00"]);

    if(_prefs.getStringList(specificTimeKey)==null)
      await _prefs.setStringList(specificTimeKey, ["00","00","00"]);

    if(_prefs.getBool(autoLapKey)==null)
      await _prefs.setBool(autoLapKey, false);

    if(_prefs.getBool(playSoundKey)==null)
      await _prefs.setBool(playSoundKey, false);

    if(_prefs.getInt(intervalToneKey)==null)
      await _prefs.setInt(intervalToneKey, 0);

    if(_prefs.getBool(stopClockKey)==null)
      await _prefs.setBool(stopClockKey, false);

    if(_prefs.getBool(specificPlaySoundKey)==null)
      await _prefs.setBool(specificPlaySoundKey, false);

    if(_prefs.getInt(specificToneKey)==null)
      await _prefs.setInt(specificToneKey, 0);

    if(_prefs.getBool(speakTimeKey)==null)
      await _prefs.setBool(speakTimeKey, false);

  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    screenRatio = h ~/ w;
    print("$screenRatio and $normalRatio");

    return WillPopScope(
      onWillPop: (){
        return hideSettings(context);
      },
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Header(),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Consumer<Laps>(
                        builder: (_, laps, __) => AnimatedContainer(
                          height: laps.lapsList.isEmpty ? w * 0.7 : w * 0.5,
                          width: laps.lapsList.isEmpty ? w * 0.7 : w * 0.5,
                          duration: duration500,
                          curve: fastOutSlowIn,
                          margin: EdgeInsets.only(
                              top: laps.lapsList.isNotEmpty
                                  ? 0
                                  : screenRatio != normalRatio
                                      ? h * 0.15
                                      : h * 0.08),
                          child: FittedBox(
                            child: GestureDetector(
                              onTap: () {
                                hideSettings(context);
                                startStopwatch(context);
                              },
                              child: Clock(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(child: LapsList()),
                    ],
                  ),
                ),
                StopWatchControls()
              ],
            ),
            Consumer<ShowSettings>(
              builder: (_, _showSettings, __) => AnimatedPositioned(
                curve: fastOutSlowIn,
                bottom: _showSettings.showSettings ? 0 : -700,
                duration: duration600,
                child: Settings(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<bool> hideSettings(BuildContext context) {
  ShowSettings settings = Provider.of<ShowSettings>(
      context,
      listen: false);
  if(settings.showSettings){
    toggleSettings(context);
    return Future.value(settings.showSettings);
  }
  return Future.value(true);
}
