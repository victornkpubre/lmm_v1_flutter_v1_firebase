import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/splash_screen.dart';

//Main Method
void main() => runApp(MyApp());

//Root or App Widget
class MyApp extends StatelessWidget {
  Color primaryColor = Colors.black;
  Color statusBarColor = LmmColors.lmmGold;
  TextStyle inputHintStyle =
      TextStyle(color: Colors.grey, fontFamily: 'Corsiva');

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(statusBarColor);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        title: 'LMM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
        ),
        home: SplashScreen());
  }
}
