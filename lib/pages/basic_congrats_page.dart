import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/match_page.dart';
import 'package:lagos_match_maker/widgets/lmm_appbar.dart';
import 'package:lagos_match_maker/widgets/lmm_bottombar.dart';

class BasicCongratsPage extends StatefulWidget {
  User user;

  BasicCongratsPage({
    @required this.user
  });

  @override
  _BasicCongratsPageState createState() => _BasicCongratsPageState();
}

class _BasicCongratsPageState extends State<BasicCongratsPage> {

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
                height: size.height*0.4,
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
                                  child: Text("Congratulation!", style: TextStyle(color: Colors.black54, fontSize: size.width*0.056, fontFamily: "Calisto"),),
                                ),

                                Container(
                                  child: Text("You have been Registered", style: TextStyle(color: Colors.black54, fontSize: size.width*0.045, fontFamily: "Calisto"), ),
                                ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(10,5,10,5),
                                  child: Text("Press okay & start matching", style: TextStyle(color: Colors.black54, fontSize: size.width*0.035, fontFamily: "Calisto"),),
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

                              if(widget.user != null){

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => MatchPage(user: widget.user,)),
                                );

                              }

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