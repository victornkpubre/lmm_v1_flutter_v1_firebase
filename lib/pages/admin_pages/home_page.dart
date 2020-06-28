import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/generic_database_manager.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/admin_pages/messages_page.dart';
import 'package:lagos_match_maker/pages/admin_pages/settings_page.dart';
import 'package:lagos_match_maker/pages/chat_page.dart';
import 'package:lagos_match_maker/widgets/admin_user_profile.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController searchController = TextEditingController();
  int unreadMessages = 0;
  List<User> users;
  List<User> user_master = [];
  List<String> premium_requests = [];
  Map<String, List<TextMessage>>  messages;
  bool playing = false;
  final player = AudioPlayer();
  AudioPlayer audioPlugin = AudioPlayer();

  @override
  void initState() {
    loadInitUsers();
    super.initState();
  }

  Future<void> loadInitUsers() async {
    List<User> temp_users = [];
    List<String> rqt = [];
    String jsonStr = await FirebaseRealtimeDatabaseManager().readAll("user");

    List list = json.decode(jsonStr); 
    list.forEach((element) {
      User user = User.fromJson(element);
      temp_users.add(user);
    });

    rqt = await FirebaseRealtimeDatabaseManager().readStringTable("premium_request");

    Map<String, List<TextMessage>>  temp_messages = await LmmSharedPreferenceManager().getAdminMessages();
  
    temp_messages = completeMessages(temp_messages, temp_users);

    setState(() {
      users = temp_users;
      user_master = List.castFrom(users);
      messages = temp_messages;
      if(rqt != null){
        premium_requests = rqt;
      }
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

  bool isUnverifiedPremium(String uid){
    bool result = false;
    premium_requests.forEach((element) {
      if(element.compareTo(uid)==0){
        result = true;
      }
    });
    return result;
  }

  bool isVerifiedPremium(User user){
    bool result = false;
    if(user.membership.compareTo("premium")==0){
      result = true;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          leading: Container(
            child: InkWell(
                child: Icon(Icons.settings, color: LmmColors.lmmGold, size: 20,),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminSettingsPage())
                  );
                },
              ),
          ),
          
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Expanded(
                child: Container(
                  child: Container(
                  height: size.width*0.5*0.12,
                  width: size.width*0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage('assets/images/title.png'),
                      fit: BoxFit.fitHeight
                    ),
                  ),
                ),
                )
              ),

              InkWell(
                child: Container(
                  height: 20,
                  width: size.width*0.15,
                  child: Stack(
                    children: <Widget>[

                      Positioned(
                        top: 0,
                        left: size.width*0.1,
                        child: Container(
                          height: 17,
                          width: 17,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                            image: AssetImage('assets/images/goldChatIcon.png'),
                              fit: BoxFit.fill
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: unreadMessages > 0,
                        child: Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                            ),
                            child: Text("$unreadMessages", style: TextStyle(fontSize: 8, color: Colors.white),),
                          ),
                        ),
                      )


                    ]
                  )
                ),
                onTap: (){

                  User user = User();
                  user.uid = user.email = "admin";

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminMessagesPage(user: user, users: user_master,))
                  );
                  
                },
              ),

            ],
          ),
        ),

        floatingActionButton: RaisedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size.width*0.3,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: searchController,
                  
                ),
              ),
              Icon(Icons.search, size: 25)
            ],
          ),
          onPressed: (){
            //if premium or basic filter by membership --- else return if contains in code name or email
            if(searchController.text != null){
              filter(searchController.text);
            }
          },
        ),

        bottomSheet: Container(
          color: Colors.black,
          width: size.width,
          height: size.height*0.1,
        ),


        body: Container( 
          color: Colors.black,
          height: size.height,
          width: size.width,
          child: users == null?
          Center(child: CircularProgressIndicator(backgroundColor: Colors.black)):
          users.length == 0?
          Center(
            child: Container(
              child: Text("No Users Found", style: TextStyle(fontSize: 25, fontFamily: "Times New Roman", color: LmmColors.lmmGold),),
            ),
          ):
          Container(
            width: size.width*0.7,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index){

                return  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/greyGradient.png'),
                          fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      width: size.width*0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/greyGradient.png'),
                                fit: BoxFit.fill
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[

                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/logo.png'),
                                      fit: BoxFit.fill
                                    ),
                                  ),
                                )

                              ]
                            ),
                          ),

                          Container(
                            color: LmmColors.lmmGrey,
                            width: size.width*0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  children: [

                                    Container(
                                      margin: EdgeInsets.fromLTRB(10,0,0,0),
                                      child: isUnverifiedPremium(users[index].uid)?
                                        Text("Premium\n(unverified)", style: TextStyle(fontSize: 20, fontFamily: "Arial Black")):
                                        isVerifiedPremium(users[index])?
                                        Text("Premium", style: TextStyle(fontSize: 20, fontFamily: "Arial Black")):
                                        Text("Basic", style: TextStyle(fontSize: 20, fontFamily: "Arial Black")),
                                    ),


                                    Visibility(
                                      visible: isVerifiedPremium(users[index]),
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(10,0,10,0),
                                        margin: EdgeInsets.fromLTRB(2.5,0,2.5,0),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/images/badge.png'),
                                            fit: BoxFit.fill
                                          ),
                                        ),
                                        height: 20,
                                        width: 13,
                                      ),
                                    )

                                  ],
                                ),

                                //Image
                                InkWell(
                                  child: Visibility(
                                    visible: users[index].pictureUrl != null,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10,0,0,0),
                                      child: users[index].pictureUrl == null?
                                      Container():
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(users[index].pictureUrl),
                                            fit: BoxFit.fill
                                          ),
                                          shape: BoxShape.circle

                                        ),

                                      )

                                    ),
                                  ),
                                  onTap: (){

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context){
                                        return Container(
                                          height: size.height*0.7,
                                          color: Colors.black,
                                          child: Center(
                                            child: Container(
                                              height: size.height*0.7,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(users[index].pictureUrl),
                                                  fit: BoxFit.fitHeight
                                                ),
                                              ),
                                            )
                                          )
                                        );
                                      }
                                    );

                                  },
                                ),

                                Container(
                                  margin: EdgeInsets.fromLTRB(20,0,0,0),
                                  child: Text(users[index].codename, style: TextStyle(fontSize: 18)),
                                ),

                                Container(
                                  margin: EdgeInsets.fromLTRB(20,0,0,0),
                                  child: Text(users[index].email),
                                ),

                                //Open Profile
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(20,5,0,5),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/goldGradient.png'),
                                        fit: BoxFit.fill
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(25))
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      child: Text("Open Profile",  
                                        style: TextStyle(fontSize: 14, fontFamily: "Times New Roman"),
                                      ),
                                    )
                                  ),
                                  onTap: () async {

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context){
                                        return Container(
                                          //padding: EdgeInsets.all(35),
                                          height: size.height,
                                          color: Colors.black,
                                          child: Center(
                                            child: Container(
                                              height: size.height*0.6,
                                              child: SingleChildScrollView(
                                                child: AdminUserProfile(user: users[index]),
                                              ),
                                            )
                                          )
                                        );
                                      }
                                    );

                                  },
                                ),

                                //Message
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(20,5,0,5),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/goldGradient.png'),
                                        fit: BoxFit.fill
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(25))
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      child: Text("Message User",  
                                        style: TextStyle(fontSize: 14, fontFamily: "Times New Roman"),
                                      ),
                                    )
                                  ),
                                  onTap: (){

                                    User user = User();
                                    user.uid = user.email = "admin";      
                                    
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ChatPage(user: user, messenger: users[index], messages: messages[users[index].uid], callBackFunction: (list){
                                        setState(() {
                                          messages[users[index].uid] = list;
                                        });
                                      },)),
                                    );

                                  },
                                ),

                                //Verify User
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(20,5,0,5),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/goldGradient.png'),
                                        fit: BoxFit.fill
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(25))
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      child: Text("Verify User",  
                                        style: TextStyle(
                                          fontSize: 14, 
                                          fontFamily: "Times New Roman", 
                                          color: users[index].membership.compareTo("premium")==0? LmmColors.lmmDarkGrey: Colors.black
                                        ),
                                      ),
                                    )
                                  ),
                                  onTap: (){

                                    if(users[index].membership.compareTo("basic")==0){
                                      verifyUser(index);
                                    }else{
                                      unVerifyUser(index);
                                    }

                                  },
                                ),

                                InkWell(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(20,5,0,5),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/goldGradient.png'),
                                          fit: BoxFit.fill
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(25))
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: Text( "Delete User",  
                                          style: TextStyle(
                                            fontSize: 14, 
                                            fontFamily: "Times New Roman",
                                            color: Colors.black
                                          ),
                                        ),
                                      )
                                    ),
                                    onTap: () async {

                                      FirebaseRealtimeDatabaseManager().deleteWithUid("user", users[index].uid);
                                      final AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: users[index].email, password: users[index].password);
                                      final FirebaseUser user = result.user;

                                      user.delete();

                                      setState(() {
                                        users.removeAt(index);
                                      });


                                    },
                                  )

                                
                              ],
                            ),
                          ),

                          Divider(color: Colors.transparent),

                          InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Text("", style: TextStyle(fontSize: 18),)

                              ],
                            ),
                          ),

                          Divider(color: Colors.transparent),

                        ],
                      ),
                    ),

                    Divider(color: Colors.transparent),
                    Divider(color: Colors.transparent)

                  ],
                );
              },
            )
          )
        )
      )
    );
  }

  verifyUser(int index){
    FirebaseRealtimeDatabaseManager().updateWIthUid("user", users[index].uid, "membership", 'premium');
    setState(() {
      users[index].membership = "premium";
    });
  }

  unVerifyUser(index){
    FirebaseRealtimeDatabaseManager().updateWIthUid("user", users[index].uid, "membership", 'basic');
    setState(() {
      users[index].membership = "basic";
    });
  }

  filter(String filter){
    users = [];


    if(filter.compareTo("")==0){
      users = List.castFrom(user_master);
    }
    else{
      if(filter.compareTo("basic") == 0){

        for (var i = 0; i < user_master.length; i++) {
          if(user_master[i].membership.compareTo('basic')==0){
              users.add(user_master[i]);
          }
        }

      }
      else{
        if(filter.compareTo("premium")==0){
          
          for (var i = 0; i < user_master.length; i++) {
            if(user_master[i].membership.compareTo('premium')==0){
              users.add(user_master[i]);
            }
          }

        }
        else{
          //By email or codename
          filter = filter.toLowerCase();
          for (var i = 0; i < user_master.length; i++) {
            String email = user_master[i].email.toLowerCase();
            String codename = user_master[i].codename.toLowerCase();
            if( email.contains(filter) || codename.contains(filter)){
              users.add(user_master[i]);
            }
          }
        }
        
      }
    }

    setState(() {
      
    });

  }

}