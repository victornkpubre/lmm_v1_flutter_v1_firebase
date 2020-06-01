

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager{
  //To Store messengers List<String>  and messages List<Map<String, List<TextMessages>>

  static Future<String> getJsonData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool exists = await isTaken(name);
    if(exists){
      print("returning ${prefs.getString(name)} to SharedPref");
      return prefs.getString(name);
    }
    else{
      print("Name Not Found");
    }

  }

  static Future<void> updateJsonData(String name, String jsonData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool exists = await isTaken(name);
    if(exists){
      prefs.setString(name, jsonData);
      print("updating $jsonData to SharedPref");
    }
    else{
      print("Name Not Found");
    }

  }

  static Future<void> addJsonData(String name, String jsonData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool exists = await isTaken(name);
    if(exists){
      print("Name Taken");
    }
    else{
      prefs.setString(name, jsonData);
      print("adding $jsonData to SharedPref");
    }

  }

  static Future<void> removeJsonData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool exists = await isTaken(name);
    if(exists){
      prefs.remove(name);
      print("removing $name from SharedPref");
    }
    else{
      print("Name Not Found");
    }

  }


  static Future<bool> isTaken(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey(name)){
        return true;
      }
      else{
        return false;
      } 
  }














}