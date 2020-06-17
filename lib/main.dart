import 'package:flutter/services.dart';
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
  if(FocusScope.of(context).hasFocus)
    FocusScope.of(context).unfocus();

  if (settings.showSettings){
    settings.showSettings = false;
    return Future.value(false);
  } else {
    return Future.value(true);
  }

}
