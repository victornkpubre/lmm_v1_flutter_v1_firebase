

import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/login_page.dart';
import 'package:lagos_match_maker/pages/membership_page.dart';

class TrialDialog extends StatefulWidget {
  bool userInitiated;

  TrialDialog({
    @required this.userInitiated
  });

  @override
  _TrialDialogState createState() => _TrialDialogState();
}

class _TrialDialogState extends State<TrialDialog> {
  TextStyle  textStyle=  TextStyle(fontSize: 16, color: LmmColors.lmmDarkGrey, fontFamily: "Times New Roman");
  TextStyle  titleStyle =  TextStyle(fontSize: 20, color: LmmColors.lmmDarkGrey, fontFamily: "Times New Roman");

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material( color: Colors.transparent, child: Container(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/goldGradient.png'),
              fit: BoxFit.fill
            ),
            borderRadius: BorderRadius.all(Radius.circular(25))
          ),
          width: size.width*0.63,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //Title
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

              Container(
                margin: EdgeInsets.all(10),
                child: widget.userInitiated? 
                Text("Login/SignUp?", textAlign: TextAlign.center, style: titleStyle,): 
                Text("Opps! You have to Sign Up to Participate", textAlign: TextAlign.center, style: titleStyle,),
              ),

              //Divider(color: Colors.transparent, height: size.height*0.01),

              Visibility(
                visible: !widget.userInitiated,
                child: InkWell(
                  child: Text("Already Registered, Login", style: TextStyle(fontFamily: "Times New Roman", fontSize: 10)),
                  onTap: (){
                    //Login Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage(user: User(),  loginState: true)),
                    );
                  },
                )
              ),

              Divider(color: Colors.transparent),

              Container(
                height: 3,
                width: size.width*0.60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/divider.png'),
                    fit: BoxFit.fill
                  ),
                ),
              ),

              Divider(color: Colors.transparent, height: size.height*0.01),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      width: size.width*0.2,
                      child: widget.userInitiated? Text("Login", textAlign: TextAlign.center, style: textStyle): Text("Sign Up",  textAlign: TextAlign.center, style: textStyle),
                    ),
                    onTap: (){

                      if(widget.userInitiated){
                        //Login Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage(user: User(),  loginState: true)),
                        );
                      }
                      else{
                        //Membership Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MembershipPage()),
                        );
                      }

                    },
                  ),

                  //VerticalDivider(color: Colors.transparent,),

                  Container(
                    height: size.height*0.06,
                    width: 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/vertical_divider.png'),
                        fit: BoxFit.fill
                      ),
                    ),
                  ),

                  //VerticalDivider(color: Colors.transparent,),

                  InkWell(
                    child: Container(
                      width: size.width*0.2,
                      child: widget.userInitiated?
                      Text("Sign Up",  textAlign: TextAlign.center, style: textStyle):
                      Text("Later",  textAlign: TextAlign.center, style: textStyle),
                    ),
                    onTap: (){
                      if(widget.userInitiated){
                        //Membership Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MembershipPage()),
                        );
                      }
                      else{
                        Navigator.of(context).pop();
                      }
                    },
                  )


                ],
              ),

              Divider(color: Colors.transparent, height: size.height*0.01),

            ],
          ),
        )
      ],
    )));
  }
}