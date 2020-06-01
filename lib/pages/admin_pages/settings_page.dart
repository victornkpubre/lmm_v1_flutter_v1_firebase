import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/generic_database_manager.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:uuid/uuid.dart';

class AdminSettingsPage extends StatefulWidget {
  @override
  _AdminSettingsPageState createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  ScrollController scrollController =  ScrollController();
  TextEditingController priceController = TextEditingController();
  TextEditingController addTipOldTextController = TextEditingController();
  TextEditingController addTipNewTextController = TextEditingController(); 
  List<Tip> tips;
  bool addingTip = false;
  


  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    String str = await getPremiumPrice();
    List<Tip> temp = await getTips();


    setState(() {
      priceController.text = str;
      tips = temp;
    });

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        body: Container(
          padding: EdgeInsets.fromLTRB(25,50,10,25),
          color: Colors.black,
          height: size.height,
          width: size.width,
          child: Center( child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Change Premium Price", style: TextStyle(color: LmmColors.lmmGold, fontFamily: "Times New Roman", fontSize: 18),),
              Divider(color: Colors.transparent, height: size.height*0.01),
              Row(
                children: [

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10,0,0,0),
                      height: 30,
                      color: Colors.white,
                      child: TextField(
                        controller: priceController,
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),

                  InkWell(
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/goldGradient.png'),
                        fit: BoxFit.fill
                      ),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Text("CHANGE",  
                            style: TextStyle(fontSize: 14, fontFamily: "Times New Roman"),
                          ),
                        ),
                      )
                    ),
                    onTap: (){
                      FirebaseRealtimeDatabaseManager().updateString("premium_price", priceController.text);
                    },
                  ),

                ],
              ),

              Divider(color: Colors.transparent, height: size.height*0.06),

              Text("Tips", style: TextStyle(color: LmmColors.lmmGold, fontFamily: "Times New Roman", fontSize: 18),),
              Divider(color: Colors.transparent, height: size.height*0.01),

              tips == null?
              Center(
                child: CircularProgressIndicator(),
              ):
              tips.length ==0?
              Visibility(
                visible: !addingTip,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0,0,0,25),
                  child: Center(
                    child: Text("No Tips Yet", style: TextStyle(color: LmmColors.lmmGold, fontFamily: "Times New Roman", fontSize: 25),)
                  )
                ),
              ):
              Visibility(
                visible: !addingTip,
                child: Container(
                  height: size.height*0.5,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: tips.length,
                    itemBuilder: (context, index){
                      TextEditingController oldTextController = TextEditingController();
                      TextEditingController newTextController = TextEditingController(); 

                      oldTextController.text = tips[index].oldText;
                      newTextController.text = tips[index].newText;

                      return Container(
                        padding: EdgeInsets.fromLTRB(0,0,0,25),
                        height: size.height*0.2,
                        width: size.width*0.95,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            Expanded( child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Text("${index + 1}", style: TextStyle(color:  Colors.grey),),
                                  ],
                                ),
                                Text("Old Text", style: TextStyle(color:  Colors.grey),),

                                Expanded(
                                  child: Container(
                                    height: 80 * 18.0,
                                    child: TextField(
                                      controller: oldTextController,
                                      maxLines: 8,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),

                                InkWell(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/goldGradient.png'),
                                        fit: BoxFit.fill
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                        child: Text("SAVE",  
                                          style: TextStyle(fontSize: 14, fontFamily: "Times New Roman"),
                                        ),
                                      ),
                                    )
                                  ),
                                  onTap: (){

                                    if(newTextController.text != null && oldTextController.text != null){
                                      FirebaseRealtimeDatabaseManager().updateWIthId("tip", tips[index].id, "newText", newTextController.text);
                                      FirebaseRealtimeDatabaseManager().updateWIthId("tip", tips[index].id, "oldText", oldTextController.text);
                                      scrollController.jumpTo(scrollController.position.maxScrollExtent + 100);
                                    }
                                    
                                  },
                                ),

                              ],
                            )),

                            Expanded( child: Column(
                              children: [
                                Text("", style: TextStyle(color:  Colors.grey),),
                                Text("New Text", style: TextStyle(color:  Colors.grey)),

                                Expanded(
                                  child: Container(
                                    height: 80 * 18.0,
                                    child: TextField(
                                      controller: newTextController,
                                      maxLines: 8,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),

                                InkWell(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/goldGradient.png'),
                                        fit: BoxFit.fill
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                        child: Text("DELETE",  
                                          style: TextStyle(fontSize: 14, fontFamily: "Times New Roman"),
                                        ),
                                      ),
                                    )
                                  ),
                                  onTap: (){
                                    FirebaseRealtimeDatabaseManager().deleteWithId("tip", tips[index].id);
                                    setState(() {
                                      tips.removeAt(index);
                                    });
                                  },
                                ),

                              ],
                            )),


                          ],
                        ),

                      );
                    },
                    
                  ),
                ),
              ),


              Visibility(
                visible: addingTip,
                child: Container(
                      height: size.height*0.2,
                      width: size.width*0.95,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [

                          Expanded( child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Old Text", style: TextStyle(color:  Colors.grey),),

                              Expanded(
                                child: Container(
                                  height: 80 * 18.0,
                                  child: TextField(
                                    controller: addTipOldTextController,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          )),

                          Expanded( child: Column(
                            children: [
                              Text("New Text", style: TextStyle(color:  Colors.grey)),

                              Expanded(
                                child: Container(
                                  height: 80 * 18.0,
                                  child: TextField(
                                    controller: addTipNewTextController,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          )),

                        ],
                      ),

                  ),
              ), 

              Visibility(
                visible: addingTip,
                child: InkWell(

                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/goldGradient.png'),
                        fit: BoxFit.fill
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Text("SAVE",  
                          style: TextStyle(fontSize: 14, fontFamily: "Times New Roman"),
                        ),
                      ),
                    )
                  ),
                  onTap: (){

                    if(addTipNewTextController.text != null && addTipOldTextController.text != null){

                      Uuid uuid = Uuid();
                      Tip tip = Tip();

                      tip.id = uuid.v1();
                      tip.newText = addTipNewTextController.text;
                      tip.oldText = addTipOldTextController.text;
                      addTipNewTextController.clear();
                      addTipOldTextController.clear();
                      
                      String jsonInput = json.encode(tip);
                      FirebaseRealtimeDatabaseManager().createWithId(jsonInput, "tip");

                      setState((){
                        tips.add(tip);
                        addingTip = !addingTip;
                      });

                    }

                  },
                ),
              ),

              
              Divider(color: Colors.transparent),
              Divider(color: Colors.transparent),


              InkWell(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/goldGradient.png'),
                      fit: BoxFit.fill
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Text(addingTip? "CLOSE ENTRY": "ADD TIP", 
                        style: TextStyle(fontSize: 14, fontFamily: "Times New Roman"),
                      ),
                    ),
                  )
                ),
                onTap: (){
                  setState(() {
                    addingTip = !addingTip;
                  });

                },
              )




            ],
          )),
        ),

      )
    );

  }

  Future<String> getPremiumPrice() async {
    String result = await FirebaseRealtimeDatabaseManager().readString("premium_price");
    return result;
  }

  Future<List<Tip>> getTips() async {
    List<String> ids =[];
    List<Tip> result = [];
    String jsonStr;

    jsonStr = await FirebaseRealtimeDatabaseManager().readTableIndexById("tip");
    List list = json.decode(jsonStr); 

    for (var i = 0; i < list.length; i++) {
      print(list[i] as String);
      ids.add(list[i] as String);
    }

    for (var i = 0; i < ids.length; i++) {
      jsonStr = await FirebaseRealtimeDatabaseManager().readByAttrWithId("tip", "id", ids[i]);
      print(jsonStr);
      Tip tip = Tip.fromJson(json.decode(jsonStr));
      result.add(tip);
    }

    return  result;
  }

}