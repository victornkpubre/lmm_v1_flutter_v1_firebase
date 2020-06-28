import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/generic_database_manager.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/pages/match_page.dart';

import 'models/index.dart';

//Check Login State


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool forward = true;
  bool animating = true;
  double logoHeight = 90;
  double logoWidth = 90;


  @override
  void initState() {
    
    Future.delayed(Duration(seconds: 3), (){
      startAnimation();
    }); 

    startApp();

    
    super.initState();
  }




  startApp() async {
    await initalNavigation();
  }

  initalNavigation() async {
    if( await LmmSharedPreferenceManager().loggedin()){
      //get user details get user from db then open homepage if complete else open profile page
      String jsonStr = await FirebaseRealtimeDatabaseManager().readByUid("user", (await LmmSharedPreferenceManager().getUserUid()));
      User user = User.fromJson(json.decode(jsonStr));

      if(user != null){

        //Navigate to MatchPage with User
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MatchPage(user: user,)),
        );

      }
      else{

        //Navigate to MatchPage without user
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MatchPage()),
        );

      }

    }else{
      //Navigate to MatchPage without user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MatchPage()),
      );
    }

  }


  startAnimation(){
    setState(() {
      //animating = true;
      logoHeight = 70;
      logoWidth = 70;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              animating?
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    forward?
                    AnimatedContainer(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.fill
                        ),
                      ),
                      height: logoHeight,
                      width: logoWidth,
                      duration: Duration(milliseconds: 800),
                      onEnd: (){
                        setState(() {
                          forward = false;
                          logoHeight = 90;
                          logoWidth = 90;
                        });
                      }, 
                    ):
                    AnimatedContainer(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.fill
                          ),
                      ),
                      height: logoHeight,
                      width: logoWidth,
                      duration: Duration(milliseconds: 300),
                      onEnd: (){
                        setState(() {
                          forward = true;
                          logoHeight = 70;
                          logoWidth = 70;
                        });
                      }, 
                    ),

                    Container(
                      width: size.width*0.9,
                      height: size.width*0.9*0.25,
                      child: Image.asset('assets/images/logoTitle.png',),
                    )
                  ],
                ),
              ): Container(),                 
            ],
          )
        
        ),
      )
      
    );
  }
}