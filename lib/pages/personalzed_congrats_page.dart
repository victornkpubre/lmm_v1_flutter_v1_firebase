import 'package:flutter/material.dart';
import 'package:lagos_match_maker/pages/membership_page.dart';
import 'package:lagos_match_maker/widgets/lmm_appbar.dart';
import 'package:lagos_match_maker/widgets/lmm_bottombar.dart';


class PersonalizedCongratsPage extends StatefulWidget {
  @override
  _PersonalizedCongratsPageState createState() => _PersonalizedCongratsPageState();
}

class _PersonalizedCongratsPageState extends State<PersonalizedCongratsPage> {
  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(

        bottomSheet: LmmBottomBar(),

        body: Container(
          color: Colors.black,
          width: size.width,
          
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //Dialog 
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/goldGradient.png'),
                    fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                height: size.height*0.6,
                width: size.width*0.75,

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

                    Divider(color: Colors.transparent),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text("Congratulation!", style: TextStyle(color: Colors.black54, fontSize: size.width*0.055, fontFamily: "Calisto"),),
                                ),

                                Divider(color: Colors.transparent),

                                Container(
                                  child: Text("Your are on your way to the Personalized Matching Process", 
                                    textAlign: TextAlign.center , 
                                    style: TextStyle(color: Colors.black54, fontSize: size.width*0.045, fontFamily: "Calisto"), 
                                  ),
                                ),

                                Divider(color: Colors.transparent),

                                Container(
                                  child: Text("Send a Whatsapp Message to 08038095991", 
                                    textAlign: TextAlign.center, 
                                    style: TextStyle(color: Colors.black54, fontSize: size.width*0.045, fontFamily: "Calisto"), 
                                  ),
                                ),

                                Divider(color: Colors.transparent),

                                Container(
                                  padding: EdgeInsets.fromLTRB(10,5,10,5),
                                  child: Text("You will be contacted by a Matchmatcher Shortly",
                                    textAlign: TextAlign.center, 
                                    style: TextStyle(color: Colors.black54, fontSize: size.width*0.035, fontFamily: "Calisto"),
                                  ),
                                )

                              ],
                            ),
                          ),

                          Container(
                            height: 3,
                            width: size.width*0.6,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/divider.png'),
                                fit: BoxFit.fill
                              ),
                            ),
                          ),

                          InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: Text("Okay", style: TextStyle(fontSize: 18, color: Colors.black54, fontFamily: "Times New Roman"),),
                                )

                              ],
                            ),
                            onTap: (){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MembershipPage()),
                              );

                            },
                          )

                        ],
                      ),
                    )

                    
                    


                  ],
                ),
              ),

              Divider(color: Colors.transparent, height: size.height*0.1,),

            ]
          )
        )
      )
    );
  }
}