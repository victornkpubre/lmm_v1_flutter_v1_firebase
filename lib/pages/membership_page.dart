import 'package:flutter/material.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/login_page.dart';
import 'package:lagos_match_maker/pages/personalzed_congrats_page.dart';
import 'package:lagos_match_maker/widgets/lmm_appbar.dart';
import 'package:lagos_match_maker/widgets/lmm_bottombar.dart';



class MembershipPage extends StatefulWidget {
  @override
  _MembershipPageState createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  
  
  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          title: LmmAppBar(),
        ),

        bottomSheet: LmmBottomBar(),

        body: Container(
          color: Colors.black,
          
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              //Logo Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                       image: DecorationImage(
                        image: AssetImage('assets/images/greyGradient.png'),
                        fit: BoxFit.fill
                      ),
                    ),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill
                          ),
                        ),
                        height: 60,
                        width: 60,
                      ),
                    )
                  )

                ], 
              ),

              Divider(color: Colors.transparent, height: size.height*0.05,),


              //Basic and Premium Btns
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  //Basic Btn
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/goldGradient.png'),
                          fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      height: size.width*0.5,
                      width: size.width*0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(20,20,20,0),
                                  child: Text("Meet & Chat with other Basic Members", style: TextStyle(color: Colors.black54, fontFamily: "Calisto", fontSize: 16), textAlign: TextAlign.center,),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(20,10,20,5),
                                  child: Text("(Free)", style: TextStyle(color: Colors.black54, fontSize: 10),),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.fromLTRB(20,10,20,10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/greyGradient.png'),
                                fit: BoxFit.fill
                              ),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Basic", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Times New Roman" ),),
                              ],
                            )
                          )

                        ],
                      )
                    ),
                    onTap: (){

                      User user = User();

                      user.membership = "basic";

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage(user: user, loginState: false,)),
                      );

                    },
                  ),


                  // Premium Btn
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/goldGradient.png'),
                          fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      height: size.width*0.5,
                      width: size.width*0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Container(
                                  padding: EdgeInsets.fromLTRB(20,20,20,0),
                                  child: Text("Meet & Chat with Anyone", style: TextStyle(color: Colors.black54, fontFamily: "Calisto", fontSize: 16), textAlign: TextAlign.center,),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(20,5,20,0),
                                  child: Text("Ice Breakers", style: TextStyle(color: Colors.black54, fontFamily: "Calisto", fontSize: 12), textAlign: TextAlign.left,),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(20,5,20,0),
                                  child: Text("Match Backtrack", style: TextStyle(color: Colors.black54, fontFamily: "Calisto", fontSize: 12), textAlign: TextAlign.left,),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(20,10,20,5),
                                  child: Text("(N4,800)", style: TextStyle(color: Colors.black54, fontSize: 10),),
                                ),

                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.fromLTRB(20,10,20,10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/greyGradient.png'),
                                fit: BoxFit.fill
                              ),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Premium", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Times New Roman" ),),
                              ],
                            )
                          )


                        ],
                      )
                    ),
                    onTap: (){

                      User user = User();

                      user.membership = "premium";

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage(user: user,  loginState: false)),
                      );

                    },
                  ),

                ],
              ),

              Divider(color: Colors.transparent, height: size.height*0.06,),

              //Personalized Btn
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/goldGradient.png'),
                          fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      height: size.width*0.4,
                      width: size.width*0.9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Container(
                                  padding: EdgeInsets.fromLTRB(30,10,30,10),
                                  child: Text("Personalize your matching process with the help of an actual lmm staff. A matchmaker will provide you with support, tips and advise", 
                                    style: TextStyle(color: Colors.black54, fontFamily: "Calisto", fontSize: 16), 
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.fromLTRB(20,10,20,10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/greyGradient.png'),
                                fit: BoxFit.fill
                              ),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Personalized Matching", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Times New Roman" ),),
                              ],
                            )
                          )


                        ],
                      )
                    ),

                    onTap: (){

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => PersonalizedCongratsPage()),
                      );
                                      
                    },

                  ),


                ],
              )


            ]
          )
        )
      )
    );
  }
}











  