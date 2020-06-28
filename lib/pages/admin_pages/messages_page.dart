import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/date_string_wrapper.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/chat_page.dart';

class AdminMessagesPage extends StatefulWidget {
  User user;
  List<User> users;

  AdminMessagesPage({
    @required this.user,
    @required this.users
  });

  @override
  _AdminMessagesPageState createState() => _AdminMessagesPageState();
}

class _AdminMessagesPageState extends State<AdminMessagesPage> {
  Map<String, List<TextMessage>> messages;

  @override
  void initState() {
    loadData();
    super.initState();
  }


  loadData() async {
    Map<String, List<TextMessage>>  temp_messages = await LmmSharedPreferenceManager().getAdminMessages();
    temp_messages = completeMessages(temp_messages, widget.users);

    setState(() {
      messages = temp_messages;
    });

  }


  Map<String, List<TextMessage>> completeMessages(Map<String, List<TextMessage>> map, List<User> temp_users){
    temp_users.forEach((user) {
      if(map[user.uid] == null){
        map[user.uid] = [];
      }
    });
    return map;
  }




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.fromLTRB(0,50,0,0),
          color: Colors.black,
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Text("Messages", style: TextStyle(color: LmmColors.lmmGold, fontFamily: "Times New Roman", fontSize: 25)),
              ),

              messages == null?
              Container(
                height: size.height*0.7,
                child: Center(
                  child: CircularProgressIndicator(backgroundColor: LmmColors.lmmGold),
                ),
              ):
              Container(
                height: size.height*0.8,
                width: size.width*0.8,
                child: ListView.builder(
                  itemCount: widget.users.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0,0,0,25),
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
                                  width: size.width*0.8,
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
                                  width: size.width*0.8,
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
                                  width: size.width*0.8,
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

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ChatPage(user: widget.user, messenger: widget.users[index], messages: messages[widget.users[index].uid], callBackFunction: (list){
                            setState(() {
                              messages[widget.users[index].uid] = list;
                            });
                          },)),
                        );

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