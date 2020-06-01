//To Store messengers List<String>  and messages  Map< String, List<TextMessages> >

import 'dart:convert';
import 'dart:core';

import 'package:lagos_match_maker/apis/shared_preference_manager.dart';
import 'package:lagos_match_maker/models/index.dart';

class LmmSharedPreferenceManager{
  

  Future<void> initMessages() async {
    if(await SharedPreferenceManager.isTaken("messages")){

    }
    else{
      await SharedPreferenceManager.addJsonData("messages", "{}");
    }
  }




  Future<Map<String, List<TextMessage>>> getMessages() async {
    if(await SharedPreferenceManager.isTaken("messages")){
      String str = await SharedPreferenceManager.getJsonData("messages");
      Map<String, dynamic> raw_map = json.decode(str);
      Map<String, List<TextMessage>> map = {};
      if(raw_map.length != 0){

        raw_map.forEach((key, list) {
          List messages = list as List;

          if(messages.length != 0){
            list.forEach((element) {
              TextMessage textMessage = TextMessage.fromJson(element);
              if(map[key] == null){
                map[key] = List<TextMessage>();
                map[key].add(textMessage);
              }else{
                map[key].add(textMessage);
              }
            });
          }
          else{
            map[key] = List<TextMessage>();
          }
          
        });
        
      }
      print("Returing messages ${map.toString()}");
      return map;
    }
    else{
      initMessages();
      print("Not Initiated");
      return {};
    }
  }

  Future<void> updateMessages( List<TextMessage> new_messages, String uid ) async {
    if(await SharedPreferenceManager.isTaken("messages")){
      Map<String, List<TextMessage>> map  = await getMessages();
      map[uid]  = new_messages;
      String str = json.encode(map);
      
      SharedPreferenceManager.updateJsonData("messages", str);
    }
    else{
      print("Not Initiated");
    }
  }

  Future<List<TextMessage>> getMessage(String uid) async {
    if(await SharedPreferenceManager.isTaken("messages")){
      String str = await SharedPreferenceManager.getJsonData("messages");
      Map<String, List<TextMessage>> map = json.decode(str);
      List<TextMessage> list = map[uid];
      return list;
    }
    else{
      print("Not Initiated");
    }
  }


  Future<void> addMessage(TextMessage message) async {
    await initMessages();

    Map<String, List<TextMessage>> map  = await getMessages();
    if(map["${message.uid}"]  == null){
      addMessenger(message.uid);
      map["${message.uid}"] = List<TextMessage>() ;
      map["${message.uid}"].add(message);
    }else{
      map["${message.uid}"].add(message);
    }

    String str = json.encode(map);
    SharedPreferenceManager.updateJsonData("messages", str);
  }

  Future<void> updateMessage(TextMessage message) async {
    Map<String, List<TextMessage>> map  = await getMessages();
    if(map["${message.uid}"]  == null){
      print("Message Not found in List");
    }else{
      map["${message.uid}"].add(message);
    }

    String str = json.encode(map);
    SharedPreferenceManager.updateJsonData("messages", str);
  }

  Future<void> addMessageByUid(TextMessage message,  String uid) async {
    await initMessages();
    Map<String, List<TextMessage>> map  = await getMessages();
    if(map[uid]  == null){
      map[uid] = List<TextMessage>();
      map[uid].add(message);
    }else{
      map[uid].add(message);
    }

    String str = json.encode(map);
    SharedPreferenceManager.updateJsonData("messages", str);
  }



  Future<void> clearMessages() async {
    SharedPreferenceManager.removeJsonData("messages");
    SharedPreferenceManager.addJsonData("messages", "{}");
  }



  Future<void> removeMessage(TextMessage message) async {
    Map<String, List<TextMessage>> map  = await getMessages();
    map["${message.uid}"].remove(message);
    String str = json.encode(map);
    SharedPreferenceManager.addJsonData("messengers", str);
  }



















Future<void> initAdminMessages() async {
    if(await SharedPreferenceManager.isTaken("admin_messages")){

    }
    else{
      await SharedPreferenceManager.addJsonData("admin_messages", "{}");
    }
  }




  Future<Map<String, List<TextMessage>>> getAdminMessages() async {
    if(await SharedPreferenceManager.isTaken("admin_messages")){
      String str = await SharedPreferenceManager.getJsonData("admin_messages");
      Map<String, dynamic> raw_map = json.decode(str);
      Map<String, List<TextMessage>> map = {};
      if(raw_map.length != 0){

        raw_map.forEach((key, list) {
          List messages = list as List;

          if(messages.length != 0){
            list.forEach((element) {
              TextMessage textMessage = TextMessage.fromJson(element);
              if(map[key] == null){
                map[key] = List<TextMessage>();
                map[key].add(textMessage);
              }else{
                map[key].add(textMessage);
              }
            });
          }
          else{
            map[key] = List<TextMessage>();
          }
          
        });
        
      }
      print("Returing admin_messages ${map.toString()}");
      return map;
    }
    else{
      initMessages();
      print("Not Initiated");
      return {};
    }
  }

  Future<void> updateAdminMessages( List<TextMessage> new_messages, String uid ) async {
    if(await SharedPreferenceManager.isTaken("admin_messages")){
      Map<String, List<TextMessage>> map  = await getMessages();
      map[uid]  = new_messages;
      String str = json.encode(map);
      
      SharedPreferenceManager.updateJsonData("admin_messages", str);
    }
    else{
      print("Not Initiated");
    }
  }

  Future<List<TextMessage>> getAdminMessage(String uid) async {
    if(await SharedPreferenceManager.isTaken("admin_messages")){
      String str = await SharedPreferenceManager.getJsonData("admin_messages");
      Map<String, List<TextMessage>> map = json.decode(str);
      List<TextMessage> list = map[uid];
      return list;
    }
    else{
      print("Not Initiated");
    }
  }


  Future<void> addAdminMessage(TextMessage message) async {
    await initMessages();

    Map<String, List<TextMessage>> map  = await getMessages();
    if(map["${message.uid}"]  == null){
      addMessenger(message.uid);
      map["${message.uid}"] = List<TextMessage>() ;
      map["${message.uid}"].add(message);
    }else{
      map["${message.uid}"].add(message);
    }

    String str = json.encode(map);
    SharedPreferenceManager.updateJsonData("admin_messages", str);
  }

  Future<void> updateAdminMessage(TextMessage message) async {
    Map<String, List<TextMessage>> map  = await getMessages();
    if(map["${message.uid}"]  == null){
      print("Message Not found in List");
    }else{
      map["${message.uid}"].add(message);
    }

    String str = json.encode(map);
    SharedPreferenceManager.updateJsonData("admin_messages", str);
  }

  Future<void> addAdminMessageByUid(TextMessage message,  String uid) async {
    await initMessages();
    Map<String, List<TextMessage>> map  = await getMessages();
    if(map[uid]  == null){
      map[uid] = List<TextMessage>();
      map[uid].add(message);
    }else{
      map[uid].add(message);
    }

    String str = json.encode(map);
    SharedPreferenceManager.updateJsonData("admin_messages", str);
  }



  Future<void> clearAdminMessages() async {
    SharedPreferenceManager.removeJsonData("admin_messages");
    SharedPreferenceManager.addJsonData("admin_messages", "{}");
  }



  Future<void> removeAdminMessage(TextMessage message) async {
    Map<String, List<TextMessage>> map  = await getMessages();
    map["${message.uid}"].remove(message);
    String str = json.encode(map);
    SharedPreferenceManager.addJsonData("admin_messengers", str);
  }























Future<void> initAdminMessengers(String uid) async {
    if(await SharedPreferenceManager.isTaken("admin_messengers")){
      Map<String, List<TextMessage>> map = await getMessages();
      if(map[uid] == null){
        map[uid] = [];
        await updateMessages([], uid);
      }
    }
    else{
      await SharedPreferenceManager.addJsonData("admin_messengers", "[]");
      await updateMessages([], uid);
    }
  }


  Future<List<String>> getAdminMessengers() async {
    if(await SharedPreferenceManager.isTaken("admin_messengers")){
      String str = await SharedPreferenceManager.getJsonData("admin_messengers");
      List<dynamic> raw_list = json.decode(str);
      List<String> list = [];
      if(raw_list.length != 0){
        raw_list.forEach((element) {
          list.add(element as String);
        });
        print("Converting List");
      }
      else{
        //Do Nothing
        print("Returning List ${list.toString()}");
        return list;
      }
      print("Returning List ${list.toString()}");
      return list;
    }
    else{
      print("Not Initiated");
      return [];
    }
  }

  updateAdminMessengers(List<String> list){
    String jsonData = json.encode(list);
    SharedPreferenceManager.updateJsonData("admin_messengers", jsonData);
  }

  



  Future<void> addAdminMessenger(String uid) async {
    //init if not init
    await initMessengers(uid);

    List<String> list = await getMessengers();
    if(list.contains(uid)){
      //already included
    }else{
      list.add(uid);
      String str = json.encode(list);
      SharedPreferenceManager.updateJsonData("admin_messengers", str);
    }
  }


  Future<void> removeAdminMessenger(String uid) async {
    List<String> list = await getMessengers();
    list.remove(uid);
    String str = json.encode(list);
    SharedPreferenceManager.addJsonData("admin_messengers", str);
  }

  
  Future<void> clearAdminMessengers() async {
    SharedPreferenceManager.removeJsonData("admin_messengers");
    SharedPreferenceManager.addJsonData("admin_messengers", "[]");
  }


























  Future<void> initMessengers(String uid) async {
    if(await SharedPreferenceManager.isTaken("messengers")){
      Map<String, List<TextMessage>> map = await getMessages();
      if(map[uid] == null){
        map[uid] = [];
        await updateMessages([], uid);
      }
    }
    else{
      await SharedPreferenceManager.addJsonData("messengers", "[]");
      await updateMessages([], uid);
    }
  }


  Future<List<String>> getMessengers() async {
    if(await SharedPreferenceManager.isTaken("messengers")){
      String str = await SharedPreferenceManager.getJsonData("messengers");
      List<dynamic> raw_list = json.decode(str);
      List<String> list = [];
      if(raw_list.length != 0){
        raw_list.forEach((element) {
          list.add(element as String);
        });
        print("Converting List");
      }
      else{
        //Do Nothing
        print("Returning List ${list.toString()}");
        return list;
      }
      print("Returning List ${list.toString()}");
      return list;
    }
    else{
      print("Not Initiated");
      return [];
    }
  }

  updateMessengers(List<String> list){
    String jsonData = json.encode(list);
    SharedPreferenceManager.updateJsonData("messengers", jsonData);
  }

  



  Future<void> addMessenger(String uid) async {
    //init if not init
    await initMessengers(uid);

    List<String> list = await getMessengers();
    if(list.contains(uid)){
      //already included
    }else{
      list.add(uid);
      String str = json.encode(list);
      SharedPreferenceManager.updateJsonData("messengers", str);
    }
  }


  Future<void> removeMessenger(String uid) async {
    List<String> list = await getMessengers();
    list.remove(uid);
    String str = json.encode(list);
    SharedPreferenceManager.addJsonData("messengers", str);
  }

  
  Future<void> clearMessengers() async {
    SharedPreferenceManager.removeJsonData("messengers");
    SharedPreferenceManager.addJsonData("messengers", "[]");
  }






































  Future<void> loginUser(String email, String password, String uid) async {
    if(await SharedPreferenceManager.isTaken("user_email")){
      SharedPreferenceManager.updateJsonData("user_email", email);
    }
    else{
      SharedPreferenceManager.addJsonData("user_email", email);
    }

    if(await SharedPreferenceManager.isTaken("user_password")){
      SharedPreferenceManager.updateJsonData("user_password", password);
    }
    else{
      SharedPreferenceManager.addJsonData("user_email", password);
    }

    if(await SharedPreferenceManager.isTaken("user_login_state")){
      SharedPreferenceManager.updateJsonData("user_login_state", "loggedin");
    }
    else{
      SharedPreferenceManager.addJsonData("user_login_state", "loggedin");
    }

    if(await SharedPreferenceManager.isTaken("user_uid")){
      SharedPreferenceManager.updateJsonData("user_uid", uid);
    }
    else{
      SharedPreferenceManager.addJsonData("user_uid", uid);
    }

  }
  

  Future<bool> loggedin() async {
    String state = await SharedPreferenceManager.getJsonData("user_login_state");
    if( state != null ){
      if(state.compareTo("loggedin")==0){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  Future<String> getUserPassword() async {
    String str = await SharedPreferenceManager.getJsonData("user_password");
    return str;
  }

  Future<String> getUserEmail() async {
    String str = await SharedPreferenceManager.getJsonData("user_email");
    return str;
  }

  Future<String> getUserUid() async {
    String str = await SharedPreferenceManager.getJsonData("user_uid");
    return str;
  }

  Future<void> logoutUser() async {

    if( await SharedPreferenceManager.isTaken("user_email")){
      SharedPreferenceManager.updateJsonData("user_email", "");
    }
    else{
      SharedPreferenceManager.addJsonData("user_email", "");
    }


    if(await SharedPreferenceManager.isTaken("user_password")){
      SharedPreferenceManager.updateJsonData("user_password", "");
    }
    else{
      SharedPreferenceManager.addJsonData("user_password", "");
    }


    if(await SharedPreferenceManager.isTaken("user_login_state")){
      SharedPreferenceManager.updateJsonData("user_login_state", "");
    }
    else{
      SharedPreferenceManager.addJsonData("user_login_state", "");
    }

  }



























  Future<void> initViewedUsers() async {
    if(await SharedPreferenceManager.isTaken("viewedUsers")){

    }
    else{
      await SharedPreferenceManager.addJsonData("viewedUsers", "[]");
    }
  }

  Future<bool> aleardyViewedUsers(String uid) async {
    await initViewedUsers();
    bool result = false;
    List<String> list = await getViewedUsers();
    print("");
    list.forEach((element) {
      if(element.compareTo(uid)==0){
        result = true;
      }
    });
    return result;
  }


  Future<List<String>> getViewedUsers() async {
    if(await SharedPreferenceManager.isTaken("viewedUsers")){
      String str = await SharedPreferenceManager.getJsonData("viewedUsers");
      List<dynamic> raw_list = json.decode(str);
      List<String> list = [];
      if(raw_list.length != 0){
        for (var i = 0; i < raw_list.length; i++) {
          dynamic element = raw_list[i];
          list.add(element as String);
        }
        print("Converting List");
      }
      print("Returning List ${list.toString()}");
      return list;
    }
    else{
      print("Not Initiated");
    }
  }



  Future<void> addToViewedUser(String uid) async {

    await initViewedUsers();

    List<String> list = await getViewedUsers();
    if(list.contains(uid)){
      //already included
    }else{
      list.add(uid);
      String str = json.encode(list);
      SharedPreferenceManager.updateJsonData("viewedUsers", str);
    }
  }


  Future<void> removeViewedUser(String uid) async {
    List<String> list = await getMessengers();
    list.remove(uid);
    String str = json.encode(list);
    SharedPreferenceManager.addJsonData("viewedUsers", str);
  }

  
  Future<void> clearViewedUsers() async {
    SharedPreferenceManager.removeJsonData("viewedUsers");
    SharedPreferenceManager.addJsonData("viewedUsers", "[]");
  }




}