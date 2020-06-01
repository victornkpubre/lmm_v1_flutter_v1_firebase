
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lagos_match_maker/apis/date_string_wrapper.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/widgets/lmm_appbar.dart';
import 'package:uuid/uuid.dart';

class FcmManager{
  String userUid;
  FirebaseMessaging _firebaseMessaging;  
  Function() callbackFunction;

  FcmManager(){
    _firebaseMessaging = FirebaseMessaging();
  }

  setCallBack(Function f){
    callbackFunction = f;
  }

  FirebaseMessaging getFirebaseObject(){
    return _firebaseMessaging;
  }

  


  //*********     ******** */

  //Init FCM Functions//

  //*********     ******** */

  void initFCM(String user_uid){
    userUid = user_uid;
    String topic = user_uid;
    _firebaseMessaging.subscribeToTopic("$topic").catchError((onError){
        print(onError.toString());
    });

    _firebaseMessaging.configure(
      onMessage: (Map< String , dynamic> message) async{ 
        final dynamic data = message['data'];
        final dynamic notification = message['notification'];
        
        TextMessage textMessage = TextMessage();
        textMessage.uid = data["sender"];
        textMessage.title = data["title"];
        textMessage.body = data["body"];
        textMessage.status = data["status"];
        textMessage.time = DateStringWrapper.withDate(DateTime.now()).jsonDateTime;

        LmmSharedPreferenceManager().addMessage(textMessage);
        print("saving message");

        callbackFunction();
        
      },
      onLaunch: (Map< String , dynamic> message) async{
        final dynamic data = message['data'];
        final dynamic notification = message['notification'];
        
        TextMessage textMessage = TextMessage();
        textMessage.uid = data["sender"];
        textMessage.title = data["title"];
        textMessage.body = data["body"];
        textMessage.status = data["status"];
        textMessage.time = DateStringWrapper.withDate(DateTime.now()).jsonDateTime;

        LmmSharedPreferenceManager().addMessage(textMessage);
        print("saving message");

        callbackFunction();
        
      },
      onResume: (Map< String , dynamic> message) async{
        //Called when app not in foreground and notification id clicked

        final dynamic data = message['data'];
        final dynamic notification = message['notification'];
        
        TextMessage textMessage = TextMessage();
        textMessage.uid = data["sender"];
        textMessage.title = data["title"];
        textMessage.body = data["body"];
        textMessage.status = data["status"];
        textMessage.time = DateStringWrapper.withDate(DateTime.now()).jsonDateTime;

        LmmSharedPreferenceManager().addMessage(textMessage);
        print("saving message");

        // callbackFunction();

        
      }
    );
  }




  

  

}