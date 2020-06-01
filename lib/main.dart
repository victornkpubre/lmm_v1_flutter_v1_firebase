import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:lagos_match_maker/splash_screen.dart';

//Main Method
void main() => runApp(MyApp());

//Root or App Widget
class MyApp extends StatelessWidget {
  Color primaryColor = Color.fromRGBO(89, 234, 193, 1.0);
  Color statusBarColor = Color.fromRGBO(0, 219, 146, 0.5);
  TextStyle  inputHintStyle = TextStyle(color: Color.fromRGBO(130, 130, 130, 0.8), fontFamily: 'Corsiva');
  
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(statusBarColor);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'NBB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: SplashScreen()
    );
  }
}