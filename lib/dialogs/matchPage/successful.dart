import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/chat_page.dart';
import 'package:lagos_match_maker/widgets/user_profile.dart';


class SuccessfulDialog extends StatefulWidget {
  User user;
  User match;

  SuccessfulDialog({
    this.user,
    this.match
  });

  @override
  _SuccessfulDialogState createState() => _SuccessfulDialogState();
}

class _SuccessfulDialogState extends State<SuccessfulDialog> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/goldGradient.png'),
          fit: BoxFit.fill
        ),
      ),
      child: Column(
        children: <Widget>[

          Divider(color: Colors.transparent),

          Text("Success!", style: TextStyle(fontFamily: "Calisto", fontSize: 35, fontWeight: FontWeight.bold, color: LmmColors.lmmBlack),),
          Text("You have a Match", style: TextStyle(fontFamily: "Calisto", fontSize: 20, fontWeight: FontWeight.bold, color: LmmColors.lmmBlack)),

          Divider(color: Colors.transparent),

          Container(
            color: Colors.black,
            width: size.width*0.8,
            height: size.height*0.6,
            child: SingleChildScrollView(
              child: UserProfile(user: widget.match)
            )
          ),

          Divider(color: Colors.transparent),

          Text("Message your Match", style: TextStyle(fontFamily: "Calisto", fontSize: 20, color: LmmColors.lmmBlack),),

          Divider(color: Colors.transparent),

          Container(
            margin: EdgeInsets.fromLTRB(0,0,0,10),
            height: 3,
            width: size.width*0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/divider.png'),
                fit: BoxFit.fill
              ),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              InkWell(
                child: Text("Later", style: TextStyle(fontSize: 30, fontFamily: "Calisto", color: LmmColors.lmmBlack),),
                onTap: (){
                    addMatch(widget.match.uid);
                    Navigator.of(context).pop();
                },
              ),

              VerticalDivider(color: Colors.transparent),

              Container(
                height: 35,
                width: 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/divider.png'),
                    fit: BoxFit.fill
                  ),
                ),
              ),

              VerticalDivider(color: Colors.transparent),

              InkWell(
                child: Text("Okay", style: TextStyle(fontSize: 30, fontFamily: "Calisto", color: LmmColors.lmmBlack),),
                onTap: (){
                  addMatch(widget.match.uid);
                  openMatchInChatPage(widget.match);
                },
              )

            ],
          ),

        ],
      )
    );
  }

  addMatch(String uid) async {
    //addMatch(user.uid);  
    await LmmSharedPreferenceManager().addMessenger(uid);
    // TextMessage textMessage = TextMessage();
    // textMessage.title = "New Match";
    // textMessage.body = "Messsage your new match";
    // textMessage.uid = "admin";
    // textMessage.status = 'sent';
    // textMessage.time = DateStringWrapper.withDate(DateTime.now()).jsonDateTime;
    // LmmSharedPreferenceManager().addMessageByUid(textMessage, uid);
  }

  openMatchInChatPage(User user){
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(user: widget.user, messenger: user, messages: [], callBackFunction: (list ) { 
        setState(() {
          
        });
      },)),
    );
  }
  
  

}