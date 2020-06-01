import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:meta/meta.dart';

class Messaging{
  static final Client client = Client();

  // !!!!!! Change key to Match current Server
  static const String serverKey = 'AAAANHYE0dg:APA91bGqOJVWQ1aNb8q56ccypWTUj5zJ9VanvBkKHiXuWmmS4tV33LsqSCBCiRK0I1_9OB2NRPQnHw6wJqjvZEpVyIwsYGiMf61MKKCO9wPoqD71mujIJs3RXJPUl23ajJ8qQVbROMpE';

  Future<void> sendNotification(BuildContext context, TextMessage text, String receiver_uid, String data) async{
    print("Sending Message");
    final response = await Messaging.sendTo(
      title: text.title,
      body: text.body,
      sender: text.uid,
      receiver: receiver_uid,
      data: data
    );

    if(response.statusCode != 200){
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('[${response.statusCode}] Error Message: ${response.body}'),
      ));
    }
    else{
       print("Offer Sent");
    }

  }

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
    @required String sender,
  }) => sendToTopic(title: title, body: body, receiver: 'all', sender: sender);

  static Future<Response> sendToTopic({
    @required String title,
    @required String body,
    @required String receiver,
    @required String sender,
  }) => sendTo(title: title, body: body, receiver: receiver, sender: sender, data: "");

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String sender,
    @required String receiver,
    @required String data,

    
  }) => client.post(
    'https://fcm.googleapis.com/fcm/send',
    body: json.encode({
      "notification": {"body": "$body","title": "$title"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK", 
        "id": "1", 
        "status": "done",
        "sender" : "$sender",
        "receiver" : "$receiver",
        "body": "$body",
        "data": "$data",
        "title": "$title"
      },
      "to": '/topics/$receiver'
    }),
    headers: {
      "Content-Type" : "application/json",
      "Authorization" : "key=$serverKey"
    }
  );




}

