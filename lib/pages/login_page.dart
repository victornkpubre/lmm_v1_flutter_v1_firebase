import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/generic_database_manager.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/admin_page.dart';
import 'package:lagos_match_maker/pages/match_page.dart';
import 'package:lagos_match_maker/pages/membership_page.dart';
import 'package:lagos_match_maker/pages/registration_page.dart';



class LoginPage extends StatefulWidget {
  User user;
  bool loginState;

  LoginPage({
    @required this.user,
    @required this.loginState
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String state = "login";

  TextEditingController adminController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypepasswordController = TextEditingController();

  @override
  void initState() {
    if(!widget.loginState){
      state = "signup";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container( 
          color: Colors.black,
          height: size.height,
          child: Center(child: SingleChildScrollView( child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              //Logo Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill
                          ),
                        ),
                        height: 70,
                        width: 70,
                      ),

                      Container(
                        width: size.width*0.8,
                        height: size.width*0.8*0.25,
                        child: Image.asset('assets/images/logoTitle.png',),
                      )
                    ],
                  ),

                ], 
              ),

              //Imputs
              Container(
                width: size.width*0.7,
                child: Column(
                  children: <Widget>[

                    //Email
                    Container(
                      child: TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        
                      ),
                    ),
                    Divider(color: Colors.white, height: 0, thickness: 3 ),

                    Divider(color: Colors.transparent),

                    //Password
                    Container(
                      child: TextField(
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        
                      ),
                    ),
                    Divider(color: Colors.white, height: 0, thickness: 3, ),

                    Divider(color: Colors.transparent),


                    //Re-type Password
                    Visibility(
                      visible: !isInLoginState(),
                      child: Container(
                        child: TextField(
                          controller: retypepasswordController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Re-Type Password",
                            hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          
                        ),
                      ),
                    ),

                    Visibility(
                      visible: !isInLoginState(),
                      child: Divider(color: Colors.white, height: 0, thickness: 3, ),
                    ),

                    Visibility(
                      visible: !isInLoginState(),
                      child: Divider(color: Colors.transparent),
                    ),

                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(40, 5, 40, 8),
                          child: Text(isInLoginState()? "Login": "Sign Up",  
                            style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                          ),
                        )
                      ),
                      onTap: (){
                        if(isInLoginState()){
                          //Login
                          if(validate()){
                            login(emailController.text, passwordController.text);
                          }
                          else{
                            //Toast
                            Fluttertoast.showToast(
                              msg: "Opps... Did You Put in Your Email and Passowrd",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: LmmColors.lmmGrey,
                              textColor: Colors.white,
                              fontSize: 16.0
                            );
                          }
                        }
                        else{
                          //Sign Up
                          if(validate()){
                            if(passwordController.text.compareTo(retypepasswordController.text)==0){
                              signup( emailController.text, passwordController.text);
                            }else{

                              //Toast
                              Fluttertoast.showToast(
                                msg: "Opps... Passowrds dont Match. Not a Good Start to Matching",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: LmmColors.lmmGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                              );                              

                            }
                          }
                          else{
                            //Toast
                            Fluttertoast.showToast(
                              msg: "Opps... Did You Put in Your Email and Password",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: LmmColors.lmmGrey,
                              textColor: Colors.white,
                              fontSize: 16.0
                            );
                          }
                        }
                      },
                    )

                  ],
                ),
              ),

              Divider(color: Colors.transparent, height: 2,),


              InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(5,8,5,15),
                  child: Text(isInLoginState()? "Click to Sign Up": "Click to Login", 
                    style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: "Times New Roman"),
                  ),
                ),
                onTap: (){

                  if(widget.loginState == true){
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MembershipPage()),
                    );
                  }

                  if(isInLoginState()){
                    setState(() {
                      state = "signup";
                    });
                  }
                  else{
                    setState(() {
                      state = "login";
                    });
                  }
                },
              ),
              


              //Page divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    color: Colors.white,
                    child: SizedBox(
                      width: size.width*0.4,
                      height: 2,
                    ),
                  ),

                  VerticalDivider(color: Colors.transparent,),

                  Text("or", style: TextStyle(fontSize: 11, color: Colors.white, fontFamily: "Corsiva"),),

                  VerticalDivider(color: Colors.transparent,),

                  Container(
                    color: Colors.white,
                    child: SizedBox(
                      width: size.width*0.4,
                      height: 2,
                    ),
                  ),

                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Divider(color: Colors.transparent),
                      Divider(color: Colors.transparent),

                      //Facebook Button
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                          decoration: BoxDecoration(
                            color: LmmColors.facebookBlue,
                            borderRadius: BorderRadius.all(Radius.circular(25))
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/facebookIcon.png'),
                                    fit: BoxFit.fill
                                  ),
                                ),
                                height: 30,
                                width: 30,
                              ),
                              //VerticalDivider(color: Colors.transparent),
                              Container(
                                child: Text("Login with Facebook", style: TextStyle(fontFamily: "Times New Roman", color: Colors.white),),
                              )

                            ],
                          ),
                        ),
                      ),

                      Divider(color: Colors.transparent),

                      //Google Button
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            border: Border.all(color: LmmColors.facebookBlue),
                          ),
                          child: Row(
                            children: <Widget>[
                              
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/googleIcon.png'),
                                    fit: BoxFit.fill
                                  ),
                                ),
                                height: 30,
                                width: 30,
                              ),
                              Container(
                                child: Text("Login with Google", style: TextStyle(fontFamily: "Times New Roman", color: Colors.white),),
                              )

                            ],
                          ),
                        ),
                      ),

                      Divider(color: Colors.transparent,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          Container(
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: size.width*0.3,
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: adminController,
                                  ),
                                ),
                                InkWell(
                                  child: Icon(Icons.settings, color: Colors.white70, size: 25),
                                  onTap: (){

                                    //Open Admin Screen
                                    if(adminController.text != null){
                                      adminController.text = adminController.text.trim();
                                      if(adminController.text.compareTo("oncode")==0){
                                        
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => AdminPage()),
                                        );

                                      }
                                    }

                                  },
                                )
                              ],
                            )
                          ),
                        ],
                      )

                    ],
                  )
                ],
              ),

            ],
          )

        ),
      )
      
    )));
  }

  bool isInLoginState(){
    return state.compareTo("login")==0;
  }

  login(String _email, String _password) async {

    //Login n get Uid
    User user = await emailLogin(_email, _password);
    widget.user.uid = user.uid;
    widget.user.email = user.email;
    widget.user.password = user.password;

    //getUser details
    String jsonStr = await FirebaseRealtimeDatabaseManager().readByUid("user", widget.user.uid);
    widget.user = User.fromJson(json.decode(jsonStr));

    //login locally
    LmmSharedPreferenceManager().loginUser(user.email, user.password, user.uid);

    Navigator.of(context).popUntil((route) => route.isFirst);

    //Navigate to MatchPage with user
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MatchPage(user: widget.user,)),
    );

  }

  signup(String _email, String _password) async {

    //Sign Up n get Uid
    //load user with email n password
    //widget.user = User();
    User user = await emailSignUp(_email, _password);
    widget.user.uid = user.uid;
    widget.user.email = user.email;
    widget.user.password = user.password;

    Navigator.of(context).popUntil((route) => route.isFirst);

    //Navigate to RegistrationPage with user
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage(user: widget.user,)),
    );


  }

  facebookLogin(){

  }

  facebookSignup(){

  }
  
  googleLogin(){

  }

  googleSignup(){

  }


  bool validate(){
    if(emailController.value.text!=null 
    && retypepasswordController.value.text!=null
    && passwordController.value.text!=null){
      return true;
    }
    else{
      return false;
    }
  }


  Future<User> emailLogin(String _email, String _password) async {
    try{
      print('Form is Valid. Email: $_email, passord: $_password');
      final AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      final FirebaseUser user = result.user;
      print('signed in: ${user.uid}');
      User user_obj = User();
      user_obj.uid = user.uid;
      user_obj.email = _email;
      user_obj.password = _password;
      return user_obj;
    }
    catch (e){
      print('Error: $e');
    }
  }

  Future<User> emailSignUp(String _email, String _password) async{
    try{
       print('Form is Valid. Email: $_email, passord: $_password');
      final AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      final FirebaseUser user = result.user;
      print('Regitered: ${user.uid}');
      User user_obj = User();
      user_obj.uid = user.uid;
      user_obj.email = _email;
      user_obj.password = _password;
      return user_obj;
    }
    catch (e){
      print('Error: $e');
    }
  }

}







