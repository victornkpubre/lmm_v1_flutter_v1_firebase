import 'package:flutter/material.dart';
import 'package:lagos_match_maker/dialogs/matchPage/trialdialog.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/match_page.dart';


class LmmBottomBar extends StatefulWidget {
  User user;

  LmmBottomBar({
    this.user
  });


  @override
  _LmmBottomBarState createState() => _LmmBottomBarState();
}


class _LmmBottomBarState extends State<LmmBottomBar> {
  bool active;


  @override
  void initState() {
    if(widget.user == null){
      active = false;
    }else{
      active = true;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/matchBtn.png'),
                  fit: BoxFit.fill
                ),
              ),
            ),
            onTap: (){

              //LmmSharedPreferenceManager().clearViewedUsers();

              //Navigate to MatchPage with user
              if(widget.user != null){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MatchPage(user: widget.user,)),
                );
              }
              else{
                showDialog(
                  context: context,
                  builder: (context){
                    return Center(
                      child: TrialDialog(userInitiated: true),
                    );
                  }
                );
              }

            },
          )
        ],
      ),
    );
  }
}