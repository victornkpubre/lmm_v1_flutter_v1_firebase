import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/date_string_wrapper.dart';
import 'package:lagos_match_maker/apis/fcm_manager.dart';
import 'package:lagos_match_maker/apis/generic_database_manager.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/chat_page.dart';
import 'package:lagos_match_maker/widgets/lmm_appbar.dart';
import 'package:lagos_match_maker/widgets/lmm_bottombar.dart';

class MessagesPage extends StatefulWidget {
  User user;

  MessagesPage({
    this.user
  });

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {

  Map<String, List<TextMessage>> messages;
  List<String> messengers;
  List<User> users;
  // FirebaseMessaging _firebaseMessaging;  
  

  @override
  void initState() {
    // FcmManager().initFCM(widget.user.uid);
    // _firebaseMessaging = FcmManager().getFirebaseObject();

    loadData();
    
    super.initState();
  }

  loadData() async {
    List<String> temp_messengers = await LmmSharedPreferenceManager().getMessengers();
    Map<String, List<TextMessage>>  temp_messages = await LmmSharedPreferenceManager().getMessages();

    List<User> temp_users;
    if(temp_messengers.length != 0){
      temp_users = await getUsers(temp_messengers);
    }
    

    setState(() {
      messages = temp_messages;
      messengers = temp_messengers;
      if(temp_messengers.length != 0){
        users = temp_users;
      }
      
    });

  }

  Future<List<User>> getUsers(List<String> uids) async {
    List<User> users = [];
    for (var i = 0; i < uids.length; i++) {
      String jsonStr =  await FirebaseRealtimeDatabaseManager().readByUid("user", uids[i]);
      User user = User.fromJson(json.decode(jsonStr));
      users.add(user);
    }
    return users;
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          title: LmmAppBar(user: widget.user),
        ),

        bottomSheet: LmmBottomBar(user: widget.user),

        body: Container(
          height: size.height,
          width: size.width,
          color: Colors.black,
          child: messengers == null? 
          Center(child: CircularProgressIndicator()):
            messengers.length == 0?
            Center(
              child: Text("No Matches Yet", style: TextStyle(color: LmmColors.lmmGold),),
            ):
            Container(
              width: size.width*0.9,
              padding: EdgeInsets.all(size.width*0.05),
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {

                    //A Message
                    return InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Container(
                                  padding: EdgeInsets.fromLTRB(10,10,10,5),
                                  width: size.width*0.9,
                                  child: Text(users[index].codename, 
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: messages[users[index].uid].length == 0?
                                      FontWeight.bold:
                                      getLastTextMessage(users[index].uid).status.compareTo("read") != 0? 
                                      FontWeight.bold: 
                                      FontWeight.normal, 
                                    )
                                  )
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(15,0,15,0),
                                  width: size.width*0.9,
                                  child: messages[users[index].uid] != null ?
                                    messages[users[index].uid].length == 0?
                                    Text("Message Your Match"):
                                    Text(getLastMessage(users[index].uid),
                                      style: TextStyle(
                                        fontWeight: getLastTextMessage(users[index].uid).status.compareTo("read") != 0? 
                                        FontWeight.bold: 
                                        FontWeight.normal, 
                                      )
                                    ):
                                    Text("Message Your Match"),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                  width: size.width*0.9,
                                  child: messages[users[index].uid] != null ?
                                    messages[users[index].uid].length == 0?
                                    Text(""):
                                    Text(dateToDuration(users[index].uid), 
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: getLastTextMessage(users[index].uid).status.compareTo("read") != 0? 
                                        FontWeight.normal: 
                                        FontWeight.normal, 
                                      )
                                    ):
                                    Text(""),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                      onTap: () {

                        if(messages[users[index].uid] == null){
                          messages[users[index].uid] = [];
                        }

                        messages[users[index].uid] = markMessagesAsRead(messages[users[index].uid], users[index].uid);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ChatPage(user: widget.user, messenger: users[index], messages: messages[users[index].uid],)),
                        );

                      },
                    );
                  },
                  
                ),
          )
        )
    );
  }

  String getLastMessage(String uid){
    List<TextMessage> list = messages[uid];
    return list[list.length - 1].body;
  }

  TextMessage getLastTextMessage(String uid){
    List<TextMessage> list = messages[uid];
    print("");
    return list[list.length - 1];
  }

  String dateToDuration(String uid){
    List<TextMessage> list = messages[uid];
    TextMessage text = list[list.length - 1];

    Duration duration;
    if(text.time != null){
      DateTime date = DateStringWrapper(text.time).dartDateTime;
      duration = DateTime.now().difference(date);
    }
    else{
      duration = Duration(seconds: 5);
    }


    if(duration.inDays > 0){
      if(duration.inDays > 7){
        int weeks = duration.inDays~/7;
        return "${weeks}w";
      }
      else{
        return "${duration.inDays}d";
      }
    }
    else{
      if(duration.inHours > 0){
        return "${duration.inHours }h";
      }
      else{
        if(duration.inMinutes > 0){
          return "${duration.inMinutes}m";
        }
        else{
          if(duration.inSeconds > 0){
            return "${duration.inSeconds}s";
          }
        }
      }
    
    }
    

  }

  User getUser(String uid){
    User temp;
    users.forEach((element) {
      if(element.uid.compareTo(uid)==0){
        temp = element;
      }
    });
    return temp;
  }


  List<TextMessage> markMessagesAsRead(List<TextMessage> list, String uid){
    
    list.forEach((textMessage) {
      textMessage.status = "read";
    });

    LmmSharedPreferenceManager().updateMessages(list, uid);

    return list;
  }


}