import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/date_string_wrapper.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/apis/messaging.dart';
import 'package:lagos_match_maker/apis/nbb_textarea.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/widgets/lmm_appbar.dart';
import 'package:lagos_match_maker/widgets/lmm_bottombar.dart';


class ChatPage extends StatefulWidget {
  User user;
  User messenger;
  List<TextMessage> messages;
  Function(List<TextMessage>) callBackFunction;
  

  ChatPage({
    @required this.user,
    @required this.messenger,
    @required this.messages,
    @required this.callBackFunction
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController scrollController =  ScrollController();
  TextEditingController messageController = TextEditingController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
      //here the sublist is already build
        scrollMessages();
      });
    }

    _firebaseMessaging.subscribeToTopic("${widget.user.uid}").catchError((onError){
        print(onError.toString());
    });

    _firebaseMessaging.configure(
      onMessage: (Map< String , dynamic> message) async{ 
        final dynamic data = message['data'];
        
        TextMessage textMessage = TextMessage();
        textMessage.uid = data["sender"];
        textMessage.title = data["title"];
        textMessage.body = data["body"];
        textMessage.status = data["status"];
        textMessage.time = DateStringWrapper.withDate(DateTime.now()).jsonDateTime;

        LmmSharedPreferenceManager().addMessage(textMessage);
        print("saving message");

        //callbackFunction();
        setState(() {
          widget.messages.add(textMessage);
        });
        scrollController.jumpTo(scrollController.position.maxScrollExtent + 100);
        
      },
      onLaunch: (Map< String , dynamic> message) async{
        final dynamic data = message['data'];
        
        TextMessage textMessage = TextMessage();
        textMessage.uid = data["sender"];
        textMessage.title = data["title"];
        textMessage.body = data["body"];
        textMessage.status = data["status"];
        textMessage.time = DateStringWrapper.withDate(DateTime.now()).jsonDateTime;

        LmmSharedPreferenceManager().addMessage(textMessage);
        print("saving message");

        //callbackFunction();
        setState(() {
          widget.messages.add(textMessage);
        });
        scrollController.jumpTo(scrollController.position.maxScrollExtent + 100);
        
      },
      onResume: (Map< String , dynamic> message) async{
        final dynamic data = message['data'];
        
        TextMessage textMessage = TextMessage();
        textMessage.uid = data["sender"];
        textMessage.title = data["title"];
        textMessage.body = data["body"];
        textMessage.status = data["status"];
        textMessage.time = DateStringWrapper.withDate(DateTime.now()).jsonDateTime;

        LmmSharedPreferenceManager().addMessage(textMessage);
        print("saving message");

        //callbackFunction();
        setState(() {
          widget.messages.add(textMessage);
        });
        scrollController.jumpTo(scrollController.position.maxScrollExtent + 100);
        
      }
    );

    super.initState();
  }


  scrollMessages(){
    scrollController.jumpTo(scrollController.position.maxScrollExtent + 100);
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          title: widget.user.uid.compareTo("admin")==0? 
            LmmAppBar():
            LmmAppBar(user: widget.user),
        ),

        bottomSheet: widget.user.uid.compareTo("admin")==0? 
          LmmBottomBar():
          LmmBottomBar(user: widget.user),

        body: Container(
          padding: EdgeInsets.all(10),
          height: size.height,
          width: size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Expanded(
                child: Container(
                  color: Colors.black,
                  child: widget.messages.length == 0?
                    Container(
                      padding: EdgeInsets.all(25),
                      child: Text("Message Your Match", style: TextStyle(color: LmmColors.lmmGold, fontSize: 15),),
                    ):
                    ListView.builder(
                      
                      controller: scrollController,
                      itemCount: widget.messages.length,
                      itemBuilder: (context, index){

                        widget.messages[index].status = 'read';
                        LmmSharedPreferenceManager().updateMessages(widget.messages, widget.messenger.uid);

                        return Container(
                          margin: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: widget.messages[index].uid.compareTo(widget.user.uid)==0?
                            MainAxisAlignment.start:
                            MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: widget.messages[index].uid.compareTo(widget.user.uid)==0?
                                BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  image: 
                                  DecorationImage(
                                    image: AssetImage('assets/images/goldGradient.png'),
                                    fit: BoxFit.fill
                                  ),
                                ):
                                BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  image: 
                                  DecorationImage(
                                    image: AssetImage('assets/images/greyGradient.png'),
                                    fit: BoxFit.fill
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  child: Text(widget.messages[index].body, style: TextStyle(color: Colors.black)),
                                  constraints: BoxConstraints(
                                    maxWidth: size.width*0.6
                                  ),
                                )
                              )
                            ],
                          ),
                        );
                      }
                    )
                ),
              ),

              Divider(color: Colors.transparent),

              Container(
                padding: EdgeInsets.fromLTRB(0,0,0,55),
                height: 160,
                width: size.width,
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.amber,
                      width: size.width,
                      child: TextArea(
                        controller: messageController,
                        height: 160,
                        maxLines: 10,
                        border: false,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      right: 15,
                      child: InkWell(
                        child: Icon(Icons.send, size: 30, color: Colors.lightBlue),
                        onTap: () async {
                          //if messages are not null
                          if(messageController.text == null || messageController.text.compareTo('')==0 ){

                          }else{
                            TextMessage textMessage = TextMessage();
                            textMessage.uid = widget.user.uid;
                            textMessage.title = "Message";
                            textMessage.status = "sent";
                            textMessage.time = DateStringWrapper.withDate(DateTime.now()).jsonDateTime;
                            textMessage.body = messageController.text;

                            //Refresh 
                            messageController.text = '';

                            await sendNotification(textMessage, widget.messenger.uid);

                            textMessage.status = "read";
                            await LmmSharedPreferenceManager().addMessageByUid(textMessage, widget.messenger.uid);

                            setState(() {
                              widget.messages.add(textMessage);
                              scrollMessages();
                            });

                            widget.callBackFunction(widget.messages);

                          }
                        },
                      ),
                    )
                  ],
                ),
              )

              
            ],
          ),
          
        )

    );
  }

  List<TextMessage> removeDuplicates(List<TextMessage> list){
    List temp;

    for (var i = 0; i < list.length; i++) {
      if(i < list.length - 2){
        if(list[i].body.compareTo(list[i+1].body)==0){
          temp.add(list[i]);
        }
      }
      else{
        temp.add(list[i]);
      }
    }
    return temp;
  }



  Future<void> sendNotification(TextMessage text, String receiver) async{
    String data = json.encode(text);
    print("Sending Message");
    final response = await Messaging.sendTo(
      title: text.title,
      body: text.body,
      sender: text.uid,
      receiver: receiver,
      data: data,
    );

    if(response.statusCode != 200){
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('[${response.statusCode}] Error Message: ${response.body}'),
      ));
    }
    else{
       print("Message Sent");
    }

  }


}