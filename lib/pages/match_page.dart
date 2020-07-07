import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/fcm_manager.dart';
import 'package:lagos_match_maker/apis/generic_database_manager.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/dialogs/matchPage/successful.dart';
import 'package:lagos_match_maker/dialogs/matchPage/trialdialog.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/widgets/lmm_appbar.dart';
import 'package:lagos_match_maker/widgets/lmm_bottombar.dart';
import 'package:lagos_match_maker/widgets/nomore_profile.dart';
import 'package:lagos_match_maker/widgets/user_profile.dart';


class MatchPage extends StatefulWidget {
  User user;
  

  MatchPage({
    this.user,
  });

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  int trial_cnt = 0;
  bool trial = false;
  int lastUserIndex = 0;
  int currentIndex = 0;
  User currentUser;
  List<User> users = [];
  List<String> user_ids = [];
  Size size;
  bool rejecting = false;
  bool accepting = false;
  bool loading = false;
  bool instructing = false;
  bool nomorematches = false;
  FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
      //here the sublist is already build
        if(widget.user == null){
          startInstructions();
        }
      });
    }

    if(widget.user == null){
      trial = true;
      loadInitUsersTrial();
    }
    else{

      FcmManager().initFCM(widget.user.uid);

      //Set Callback Fuction
      FcmManager().setCallBack((){
        setState(() {
          
        });
      });

      _firebaseMessaging = FcmManager().getFirebaseObject();
      
    
      loadInitUsers();
    }
    
    super.initState();
  }

  startInstructions(){

    setState(() {
      instructing = true;
    });

    Future.delayed(Duration(seconds: 12), (){
      setState(() {
        instructing = false;
      });
    });
  }

  loadInitUsersTrial() async {

    String jsonStr = await FirebaseRealtimeDatabaseManager().readTableIndex("user");
    List list = json.decode(jsonStr); 
    list.forEach((element) {
      user_ids.add(element as String);
    });


    //load users
    users = await getUsersTiral();
    

    if(users.length != 0){
      setState(() {
        currentUser = users[currentIndex];
      });
    }
    else{
      setState(() {
        currentUser = widget.user;
        nomorematches = true;
      });
    }

  }

  Future<void> loadInitUsers() async {
    String jsonStr = await FirebaseRealtimeDatabaseManager().readTableIndex("user");
    List list = json.decode(jsonStr); 
    list.forEach((element) {
      user_ids.add(element as String);
    });


    //load more users
    String sex;
    if(widget.user.sex.compareTo("male")==0){
      sex = "female";
    }
    else{
      sex = "male";
    }

    users = await getUsers(sex);
    

    if(users.length != 0){
      setState(() {
        currentUser = users[currentIndex];
      });
    }
    else{
      setState(() {
        currentUser = widget.user;
        nomorematches = true;
      });
    }
 
  }

  Future<List<User>> getUsersTiral() async {

    List<User> temp = [];
    bool downloading = true;
    int downloading_index = 0;
    int cnt = 4;

    while(temp.length == 0 && downloading){
      temp = await loadUsers(downloading_index, cnt);
      if(temp.length == 0){
        if(downloading_index < user_ids.length){
          int number = downloading_index + cnt + 1;

          if(number + cnt >= user_ids.length){
            downloading_index = number;
            cnt = user_ids.length - downloading_index;
          }
          else{
            downloading_index = number;
          }
          
        }
        else{
          downloading = false;
        }
      }
    }

    return temp;

  }

  Future<List<User>> getUsers(String sex) async {

    List<User> temp = [];
    bool downloading = true;
    int downloading_index = 0;
    int cnt = 4;

    while(temp.length == 0 && downloading){
      temp = await loadUsersByFilter(downloading_index, cnt, "sex", sex);
      if(temp.length == 0){
        if(downloading_index < user_ids.length){
          int number = downloading_index + cnt;

          if(number + cnt >= user_ids.length){
            downloading_index = number;
            cnt = user_ids.length - downloading_index;
          }
          else{
            downloading_index = number;
          }
          
        }
        else{
          downloading = false;
        }
      }else{
        downloading = false;
      }
    }

    return temp;

  }

  


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      child: Scaffold(

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          title: trial || users == null? LmmAppBar(): LmmAppBar(user: widget.user),
        ),

        bottomSheet: trial || users == null? LmmBottomBar(): LmmBottomBar(user: widget.user),

        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/goldGradient.png'),
              fit: BoxFit.fill
            ),
          ),

          child: Stack(
            children: <Widget>[

              currentUser == null?
              Center(child: CircularProgressIndicator(backgroundColor: Colors.black)):
              Center(
                child: Draggable<String>( 
                  feedback: Opacity(
                    opacity: 0.25,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0,0,0,55),
                      height: size.height*0.6,
                      child: SingleChildScrollView(
                        child: nomorematches? NoMoreProfile(user: widget.user): UserProfile(user: currentUser),
                      )
                    )
                  ),
                  childWhenDragging: Container(),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0,0,0,55),
                    height: size.height*0.6,
                    child: SingleChildScrollView(
                        child: nomorematches? NoMoreProfile(user: widget.user): UserProfile(user: currentUser),
                      )
                  ),
                  onDragEnd: (details){
                    if(rejecting == true){
                      rejectUser();
                    }
                    if(accepting == true){
                      acceptUser();
                    }
                    if(rejecting == true || accepting == true){
                      setState(() {
                        rejecting = false;
                        accepting = false;
                      });
                    }
                  },
                )
              ),


              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  height: size.height,
                  width: size.width*0.3,
                  child: DragTarget<String>(
                    onWillAccept: (data) {
                      if(rejecting == false){
                        setState(() {
                          rejecting = true;
                          accepting = false;
                        });
                      }
                      else{
                        rejecting = true;
                      }
                      return true;
                    },
                    builder: (BuildContext context, List<String> candidateData, List<dynamic> rejectedData) { 

                    },
                    
                  ),
                )
              ),

              Positioned(
                right: 0,
                top: 0,
                child: SizedBox(
                  height: size.height,
                  width: size.width*0.3,
                  child: DragTarget<String>(
                    onWillAccept: (data) {
                      if(accepting == false){
                        setState(() {
                          accepting = true;
                          rejecting = false;
                        });
                      }
                      else{
                        accepting = true;
                      }
                      return true;
                    },
                    builder: (BuildContext context, List<String> candidateData, List<dynamic> rejectedData) {
                      
                    },
                  ),
                )
              ),


              Positioned(
                right: 0,
                top: 0,
                child: Visibility(
                  visible: accepting,
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(
                      color: Colors.grey,
                      child: SizedBox(
                        height: size.height,

                        width: size.width*0.3,
                        child: Center(
                          child: Opacity(
                            opacity: 0.6,
                            child: Icon(Icons.check, color: Colors.green, size: 50),
                          )
                        )
                      ),
                    )
                  ),
                )
              ),

              Positioned(
                left: 0,
                top: 0,
                child: Visibility(
                  visible: rejecting,
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(
                      color: Colors.grey,
                      child: SizedBox(
                        height: size.height,
                        width: size.width*0.3,
                        child: Center(
                          child: Opacity(
                            opacity: 0.6,
                            child: Icon(Icons.close, color: Colors.red, size: 50),
                          )
                        )
                      ),
                    )
                  ),
                )
              ),
              

              loading?
              Center(child: CircularProgressIndicator(backgroundColor: LmmColors.lmmGold  )):
              Container(),
              

              instructing?
              Container(
                color: Color.fromRGBO(180, 180, 180, 0.6),
                width: size.width,
                height: size.height,
                child: Column(
                  
                  children: [
                    Divider(color: Colors.transparent,),
                    Text("Loading Settings...", style: TextStyle(fontFamily: "Times New Roman", fontSize: 20),),
                  ],
                )
              ):
              Container(),


              instructing?
              Positioned(
                left: size.width*0.02,
                top: size.height*0.20,
                child: Container(
                  width: size.width*0.45,
                  height: size.width*0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/swipe_left.png'),
                      fit: BoxFit.fitHeight
                    )
                  ),
                ),
              ):
              Container(),

              instructing?
              Positioned(
                right: size.width*0.02,
                bottom: size.height*0.20,
                child: Container(
                  width: size.width*0.45,
                  height: size.width*0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/swipe_right.png'),
                      fit: BoxFit.fitHeight
                    ),
                  ),
                ),
              ):
              Container(),
              
            ],
          )
          
        ),
        
      ),
      
    );
  }

  Future<List<User>> loadUsersByFilter(int index, int cnt, String attr, String value) async { //0 - cnt

    List<User> tempUsers = [];

    for (var i = index; i < index + cnt; i++) {
      String jsonStr = await FirebaseRealtimeDatabaseManager().readByUid("user", user_ids[i]);
      Map<String, dynamic> tempUser = json.decode(jsonStr);

      if(tempUser != null){
        lastUserIndex = i;
        String attribute = tempUser[attr];
        if(attribute.compareTo(value)==0){
          String uid = tempUser["uid"];
          //if uid is among viewedUsers do not add unless user is premium
          bool viewed = await LmmSharedPreferenceManager().aleardyViewedUsers(uid);
          if(!viewed){
            tempUsers.add(User.fromJson(tempUser));
            print("$i");
          }
        }
      } 
    }

    return tempUsers;

  }

  Future<List<User>> loadUsers(int index, int cnt) async { //Inclusive

    List<User> tempUsers = [];

    for (var i = index; i < index + cnt + 1; i++) {
      String jsonStr = await FirebaseRealtimeDatabaseManager().readByUid("user", user_ids[i]);
      Map<String, dynamic> tempUser = json.decode(jsonStr);
      if(tempUser != null){
        lastUserIndex = i;
        // String attribute = tempUser[attr];
        //if(attribute.compareTo(value)==0){
          String uid = tempUser["uid"];
          //if uid is among viewedUsers do not add unless user is premium
          bool viewed = await LmmSharedPreferenceManager().aleardyViewedUsers(uid);
          if(!viewed){
            tempUsers.add(User.fromJson(tempUser));
          }
        //} 
      }

    }

    return tempUsers;

  }

  rejectUser() async {
    if(!trial){

      if(await LmmSharedPreferenceManager().aleardyViewedUsers(currentUser.uid)){
        //addViewedUser
        LmmSharedPreferenceManager().addToViewedUser(currentUser.uid);
      }
      
    }   
    //show next User
    nextUser();
  }

  acceptUser() async {
    if(!trial){
      //create list if empty
      if(widget.user.matches == null){
        widget.user.matches = [];
      }

      bool viewed = await LmmSharedPreferenceManager().aleardyViewedUsers(currentUser.uid);
      if(!viewed){
        //addViewedUser
        LmmSharedPreferenceManager().addToViewedUser(currentUser.uid);
      }

      //add user uid to matches 
      bool matched = await alreadyMatched(currentUser.uid);
      if( !(currentUser.uid.compareTo(widget.user.uid)==0) && !matched ){
        widget.user.matches.add(currentUser.uid);

        //update database
        FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "matches", widget.user.matches);
        
        //check for successful matches
        checkMatches();
      }
    }
    
    //show next User
    await nextUser();

    //LmmSharedPreferenceManager().clearMessengers();
    //LmmSharedPreferenceManager().clearViewedUsers();
  }



  nextUser() async {
    setState(() {
      loading = true;
    });

    if(trial){
      if(trial_cnt > 2){
        showDialog(
          context: context,
          builder: (context){
            return Center(
              child: TrialDialog(userInitiated: false),
            );
          }
        );
        trial_cnt = 0;
      }
      else{
        trial_cnt++;
      }
    }

    if(nomorematches == true){

      //Do Nothing

    }else{
      if(currentIndex < users.length - 1){
        //advance
        currentIndex++;
        setState(() {
          currentUser = users[currentIndex];
        });
      }
      else{
        //load more users
        String sex;
        if(widget.user.sex.compareTo("male")==0){
          sex = "female";
        }
        else{
          sex = "male";
        }
        
        List<User> temp = await getUsers(sex);

        if(temp.length == 0){
          //showNoMoreMatchPage()
          if(widget.user.membership.compareTo("premium")==0){
            setState(() {
              currentIndex = 0;
            });
          }
          else{
            setState(() {
              nomorematches = true;
            });
          }

        }
        else{
          //add temp to end
          users.addAll(temp);
        }
      }

    }

    setState(() {
      loading = false;
    });

  }



  checkMatches() async {
    //Loop user matches
    widget.user.matches.forEach((element) async {
      String uid = element as String;
      String jsonStr = await FirebaseRealtimeDatabaseManager().readByUid("user", uid);
      User user = User.fromJson(json.decode(jsonStr));
      bool matched = await alreadyMatched(user.uid);

      //if user is not current user and not matched already
      if( !(user.uid.compareTo(widget.user.uid)==0) && !matched){
        
        if(user.matches != null){
          //Loop downloaded user matches
          user.matches.forEach((element){
            if(widget.user.uid.compareTo(element)==0){

              //showMatchDialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context){
                  return Material(
                    child: WillPopScope(
                      onWillPop: () {  },
                      child: SuccessfulDialog(match: user, user: widget.user),
                    )
                  );
                }
              );

            }
          });
        }
      }

    }); 

  }


  Future<bool> alreadyMatched(String uid) async {
    List<String> matches = await LmmSharedPreferenceManager().getMessengers();
    bool result = false;
    matches.forEach((element) {
      if(element.compareTo(uid)==0){
        result = true;
      }
    });
    return result;
  }




}