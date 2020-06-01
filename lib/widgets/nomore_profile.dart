import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/models/index.dart';



class NoMoreProfile extends StatefulWidget {
  User user;

  NoMoreProfile({
    this.user
  });

  @override
  _NoMoreProfileState createState() => _NoMoreProfileState();
}

class _NoMoreProfileState extends State<NoMoreProfile> {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      type: MaterialType.transparency,

      child: Container(
      width: size.width*0.75,
      height: size.height*0.75,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/greyGradient.png'),
                fit: BoxFit.fill
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.fill
                    ),
                  ),
                )

              ]
            ),
          ),

          Divider(color: Colors.transparent),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Opps!", style: TextStyle(color: LmmColors.lmmGold, fontFamily: "Times New Roman", fontSize: 20)),
                Text("No More Matches", style: TextStyle(color: LmmColors.lmmGold, fontFamily: "Times New Roman", fontSize: 20)),

                Divider(color: Colors.transparent),
                Divider(color: Colors.transparent),

                Text("Check Back Later", style: TextStyle(color: LmmColors.lmmGold, fontFamily: "Calisto", fontSize: 20))
              ],
            ),
          )
        ],
      ),
    ));
  }
}