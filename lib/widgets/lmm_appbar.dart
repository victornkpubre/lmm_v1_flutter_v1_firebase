import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/date_string_wrapper.dart';
import 'package:lagos_match_maker/apis/fcm_manager.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/dialogs/matchPage/trialdialog.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/messages_page.dart';
import 'package:lagos_match_maker/pages/profile_page.dart';


class LmmAppBar extends StatefulWidget {
  User user;

  LmmAppBar({
    this.user
  });

  @override
  _LmmAppBarState createState() => _LmmAppBarState();

  

}

class _LmmAppBarState extends State<LmmAppBar> {
  FirebaseMessaging _firebaseMessaging;
  int unreadMessages = 0;

  @override
  void initState() {
    loadData();
    //_timer();

    super.initState();
  }

  loadData() async {
    int cnt =0;
    Map<String, List<TextMessage>> map = await LmmSharedPreferenceManager().getMessages();
    map.values.forEach((list) {
      if(list != null){
        list.forEach((text) {
          if(text.status.compareTo("read") != 0 ){
            cnt++;
          }
        });
      }
    });
    setState(() {
      unreadMessages = cnt;
    });
  }

  void _timer() {
    Future.delayed(Duration(seconds: 60)).then((_) {
      loadData();
      _timer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              InkWell(
                child: Container(
                  height: 15,
                  width: 17,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage('assets/images/goldProfileIcon.png'),
                      fit: BoxFit.fill
                    ),
                  ),
                ),
                onTap: (){
                  if(widget.user != null){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user))
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
              ),

              Container(
                height: size.width*0.5*0.12,
                width: size.width*0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                  image: AssetImage('assets/images/title.png'),
                    fit: BoxFit.fill
                  ),
                ),
              ),

              InkWell(
                child: Container(
                  height: 20,
                  width: 20,
                  child: Stack(
                    children: <Widget>[

                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                            image: AssetImage('assets/images/goldChatIcon.png'),
                              fit: BoxFit.fill
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: unreadMessages > 0,
                        child: Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                            ),
                            child: Text("$unreadMessages", style: TextStyle(fontSize: 8, color: Colors.white),),
                          ),
                        ),
                      )


                    ]
                  )
                ),
                onTap: (){
                  if(widget.user != null){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MessagesPage(user: widget.user))
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
              ),

            ],
          ),
    );
  }
}