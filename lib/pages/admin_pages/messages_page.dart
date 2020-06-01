import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/date_string_wrapper.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/models/index.dart';

class AdminMessagesPage extends StatefulWidget {
  List<User> users;

  AdminMessagesPage({
    @required this.users
  });

  @override
  _AdminMessagesPageState createState() => _AdminMessagesPageState();
}

class _AdminMessagesPageState extends State<AdminMessagesPage> {
  Map<String, List<TextMessage>> messages;
  List<String> messengers;



  loadData() async {
    List<String> temp_messengers = await LmmSharedPreferenceManager().getAdminMessengers();
    Map<String, List<TextMessage>>  temp_messages = await LmmSharedPreferenceManager().getAdminMessages();
    

    setState(() {
      messages = temp_messages;
      messengers = temp_messengers;
      
    });

  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(60),
          color: Colors.black,
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Container(
                child: Text("Messages", style: TextStyle(color: LmmColors.lmmGold, fontFamily: "Times New Roman", fontSize: 25)),
              ),

              Container(
                child: ListView.builder(
                  itemCount: widget.users.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0,0,0,25),
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
                                  child: Text(widget.users[index].codename, 
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: messages[widget.users[index].uid].length == 0?
                                      FontWeight.bold:
                                      getLastTextMessage(widget.users[index].uid).status.compareTo("read") != 0? 
                                      FontWeight.bold: 
                                      FontWeight.normal, 
                                    )
                                  )
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(15,0,15,0),
                                  width: size.width*0.9,
                                  child: messages[widget.users[index].uid] != null ?
                                    messages[widget.users[index].uid].length == 0?
                                    Text(""):
                                    Text(getLastMessage(widget.users[index].uid),
                                      style: TextStyle(
                                        fontWeight: getLastTextMessage(widget.users[index].uid).status.compareTo("read") != 0? 
                                        FontWeight.bold: 
                                        FontWeight.normal, 
                                      )
                                    ):
                                    Text(""),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                                  width: size.width*0.9,
                                  child: messages[widget.users[index].uid] != null ?
                                    messages[widget.users[index].uid].length == 0?
                                    Text(""):
                                    Text(dateToDuration(widget.users[index].uid), 
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: getLastTextMessage(widget.users[index].uid).status.compareTo("read") != 0? 
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

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => ChatPage(user: widget.user, messenger: users[index], messages: messages[users[index].uid],)),
                        // );

                      },
                    );
                  }
                ),
              )

            ],
          ),
        ),
      ),
      
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

  // User getUser(String uid){
  //   User temp;
  //   users.forEach((element) {
  //     if(element.uid.compareTo(uid)==0){
  //       temp = element;
  //     }
  //   });
  //   return temp;
  // }


  List<TextMessage> markMessagesAsRead(List<TextMessage> list, String uid){
    
    list.forEach((textMessage) {
      textMessage.status = "read";
    });

    LmmSharedPreferenceManager().updateMessages(list, uid);

    return list;
  }

}