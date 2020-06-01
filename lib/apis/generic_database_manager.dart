
///*** Generic Object CRUD ***///
  
  // Obj Table - Structure
  //
  // users_table ---> count : 2 
  //             |--> index_table ---> 0 --> "uid" : XKJNWNW24JN24N2NON
  ///            |                |--> 1 --> "uid" : XKJNWNW24JN24N2NON
  ///            |
  ///            |--> XKJNWNW24JN24N2NON ---> uid : XKJNWNW24JN24N2NON
  ///            |                       |--> name : "Koko"
  ///            |                       |--> age : 4
  ///            |                       
  ///            |--> XKJNWNW24JN24N2NON |--> uid : XKJNWNW24JN24N2NON
  ///                                    |--> name : "Koko"
  ///                                    |--> age : 4
  /// 
  /// 
  // Primitive Table - Structure
  //
  // address_table ---> count : 2
  //               |--> 0 : XKJNWNW24JN24N2NON
  ///              |
  ///              |--> 1 : XKJNWNW24JN24N2NON
  

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeDatabaseManager{
  
  
  //Create(json string object, object name)
  Future<String> createWithUid(String jsonInput, String object_name) async {
    object_name = object_name.toLowerCase();

    Map<String, dynamic> data = json.decode(jsonInput);

    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${object_name}s_table");
    DatabaseReference table_index = database_table.child("table_index");
    int count = await getCount(object_name);
    
    //send information
    if(data["uid"] == null){
      //return json does not contain uid
      return "Unsuccessful - json doesn't contain uid attribute";
    }else{
      bool exist = await uidExists(object_name,data["uid"]);
      if(exist) {
        return "Uid already Exists";
      }else{
        //send data to index table
        table_index.child('$count').set({"uid" : data["uid"]});
        //send data to object table
        database_table.child(data["uid"]).set(data);
      }
    }

    //Increment count
    incrementCount(object_name);

    return "Successful";
  }






  Future<bool> tableExists(String table) async {
    DataSnapshot database_table = await FirebaseDatabase.instance.reference().child("${table}s_table").once();

    if(database_table.value != null){
      return true;
    }else{
      return false;
    }
  }





  Future<bool> uidExists(String table, String uid) async{
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");

    DataSnapshot result = await database_table.child(uid).once();
    if(result.value != null){
      return true;
    }else{
      return false;
    }

  }

  Future<int> getCount(String object_name) async{
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${object_name}s_table");
    DatabaseReference table_count = database_table.child("count");
    //getCount
    final snapshot = await table_count.once();
    if(snapshot.value == null){
      database_table.set({"count" : 0});
      return 0;
    }else{
      return snapshot.value;
    }
  }

  void incrementCount(String object_name) async{
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${object_name}s_table");
    DatabaseReference table_count = database_table.child("count");
    int count;


    //getCount
    final snapshot = await table_count.once();
    if(snapshot.value == null){
      database_table.set({"count" : 0});
      count = 0;
    }else{
      count = snapshot.value;
    }

    //incrementCount
    count++;
    //updateCount
    database_table.update({"count" : count});
  }

  void decreaseCount(String object_name) async{
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${object_name}s_table");
    DatabaseReference table_count = database_table.child("count");
    int count;


    //getCount
    final snapshot = await table_count.once();
    if(snapshot.value == null){
      database_table.set({"count" : 0});
      count = 0;
    }else{
      count = snapshot.value;
    }

    //incrementCount
    count--;
    //updateCount
    database_table.update({"count" : count});
  }

  //Read
  Future<String> readByAttr( String table, String attribute, String attribute_value) async{
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");

    List values = [];
    int count = await getCount(table);

    for (var i = 0; i < count; i++) {
      String uid = await getUid(table, i);
      DataSnapshot result = await database_table.child(uid).once();
      if(attribute_value.compareTo(result.value[attribute])==0){
        Map map = result.value;
        values.add(map);
      }
    }

    return json.encode(values);
  }

  Future<String> readByAttrWithId( String table, String attribute, String attribute_value) async{
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");

    Map map = {};
    int count = await getCount(table);

    for (var i = 0; i < count; i++) {
      String id = await getId(table, i);
      DataSnapshot result = await database_table.child(id).once();
      if(attribute_value.compareTo(result.value[attribute])==0){
        map = result.value;
      }
    }

    return json.encode(map);
  }

  Future<String> readByUid( String table, String uid) async{
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");

    DataSnapshot result = await database_table.child(uid).once();
    Map values = result.value;

    //Firebase Map to json object od json string
    return json.encode(values);
  }

  Future<String> readAll(String table) async {
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    DatabaseReference table_count = database_table.child('count');

    List<Map> mapList = [];

    await table_count.once().then((count_value) async{
      int count = count_value.value;
      for (var i = 0; i < count; i++) {
        String uid = await getUid(table, i);
        await database_table.child(uid).once().then((value) {
          Map map = value.value;
          mapList.add(map);
        });
      }
    });

    return json.encode(mapList);
  }


  Future<String> readTableIndex(String table) async {
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    DatabaseReference table_count = database_table.child('count');
    DatabaseReference index_table = database_table.child('table_index');

    List list = [];

    await table_count.once().then((count_value) async{
      int count = count_value.value;
      for (var i = 0; i < count; i++) {
        DataSnapshot uid = await index_table.child("$i").once();
        list.add(uid.value["uid"]);
      }
    });

    return json.encode(list);
  }

  Future<String> readTableIndexById(String table) async {
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    DatabaseReference table_count = database_table.child('count');
    DatabaseReference index_table = database_table.child('table_index');

    List list = [];

    await table_count.once().then((count_value) async{
      int count = count_value.value;
      for (var i = 0; i < count; i++) {
        DataSnapshot uid = await index_table.child("$i").once();
        list.add(uid.value["id"]);
      }
    });

    return json.encode(list);
  }

  

  Future<String> getUid(String table, int i) async{
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    DatabaseReference table_index = database_table.child("table_index");

    DataSnapshot uidRef = await (table_index.child("$i").child("uid").once());
    return uidRef.value;
  }


  Future<String> getId(String table, int i) async{
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    DatabaseReference table_index = database_table.child("table_index");

    DataSnapshot uidRef = await (table_index.child("$i").child("id").once());
    return uidRef.value;
  }

  

  //Update
  String updateWIthUid(String table, String uid, String attr, dynamic attr_value){
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    database_table.child(uid).update({ attr : attr_value }); // Only works if key is a String 
    return 'Successful';
  }


  //Delete
  Future<String> deleteWithUid(String table, String uid) async{

    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    DatabaseReference table_index = database_table.child("table_index");

    database_table.child(uid).remove();

    int count = await getCount(table);

    for (var i = 0; i < count; i++) {
      String currentUid = await getUid(table, i);
      if(currentUid.compareTo(uid) == 0){

        table_index.child("$i").remove();
        break;

      }
    }

    //Decrease count 
    decreaseCount(table);
  }

  //Functions to Edit to Databbase Structure
  //E.g Add a new child without lossing current data



























Future<String> createWithId(String jsonInput, String object_name) async {
    object_name = object_name.toLowerCase();

    Map<String, dynamic> data = json.decode(jsonInput);

    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${object_name}s_table");
    DatabaseReference table_index = database_table.child("table_index");
    int count = await getCount(object_name);
    
    //send information
    if(data["id"] == null){
      //return json does not contain uid
      return "Unsuccessful - json doesn't contain uid attribute";
    }else{
      bool exist = await uidExists(object_name,data["id"]);
      if(exist) {
        return "Uid already Exists";
      }else{
        //send data to index table
        table_index.child('$count').set({"id" : data["id"]});
        //send data to object table
        database_table.child(data["id"]).set(data);
      }
    }

    //Increment count
    incrementCount(object_name);

    return "Successful";
  }





  //Update
  String updateWIthId(String table, String id, String attr, dynamic attr_value){
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    database_table.child(id).update({ attr : attr_value }); // Only works if key is a String 
    return 'Successful';
  }


  //Delete
  Future<String> deleteWithId(String table, String id) async{

    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    DatabaseReference table_index = database_table.child("table_index");

    database_table.child(id).remove();

    int count = await getCount(table);

    for (var i = 0; i < count; i++) {
      String currentUid = await getUid(table, i);
      if(currentUid.compareTo(id) == 0){

        table_index.child("$i").remove();
        break;

      }
    }

    //Decrease count 
    decreaseCount(table);
  }
















  















  addString(String name, String value) async {
    DatabaseReference root = FirebaseDatabase.instance.reference();
    root.child(name).set(value);
  }


  Future<String> readString(String name) async {
    DatabaseReference root = FirebaseDatabase.instance.reference();
    DataSnapshot result =  await root.child(name).once();
    String str;
    if(result != null){
      str = result.value;
    }
    else{
      str = "";
    }
    return str;
  }


  updateString(String name, String value){
    DatabaseReference root = FirebaseDatabase.instance.reference();
    root.child(name).set(value);
  }


  removeString(String name){
    DatabaseReference root = FirebaseDatabase.instance.reference();
    root.child(name).set("");
  }






























  addToStringTable(String table, String value) async {
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");
    int count = await getCount(table);
    database_table.child("$count").set(value);
    incrementCount(table);
  }

  Future<List<String>> readStringTable(String table) async {
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");

    List<String> values = [];
    int count = await getCount(table);

    for (var i = 0; i < count; i++) {
      DataSnapshot result = await database_table.child("$i").once();
      String str = result.value;
      values.add(str);
    }

    return values;
  }

  updateStringsByValue(String table, String oldStr, String newStr) async {
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");

    int count = await getCount(table);

    for (var i = 0; i < count; i++) {
      DataSnapshot result = await database_table.child("$i").once();
      String str = result.value;
      if(str.compareTo(oldStr)==0){
        database_table.child("$i").set(newStr);
      }
    }

  }

  deleteStringByValue(String table, String value) async {
    DatabaseReference database_table = FirebaseDatabase.instance.reference().child("${table}s_table");

    int count = await getCount(table);

    for (var i = 0; i < count; i++) {
      DataSnapshot result = await database_table.child("$i").once();
      String str = result.value;
      if(str.compareTo(value)==0){
        database_table.child("$i").set("");
      }
    }
  }











































  

}
