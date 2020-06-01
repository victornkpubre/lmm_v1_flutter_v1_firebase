import 'package:age/age.dart';
import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/date_string_wrapper.dart';
import 'package:lagos_match_maker/models/index.dart';



class AdminUserProfile extends StatefulWidget {
  User user;


  AdminUserProfile({
    @required this.user
  });

  @override
  _AdminUserProfileState createState() => _AdminUserProfileState();
}

class _AdminUserProfileState extends State<AdminUserProfile> {
  @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      TextStyle  detailTextStyle = TextStyle(color: LmmColors.lmmGold, fontFamily: "Times New Roman", fontSize: size.width*0.05);
      
      return Material(
        type: MaterialType.transparency,
        child: Container(
                  width: size.width*0.75,
                  height: size.height*0.75,
                  color: Colors.black,

                  child: Column(
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.fromLTRB(0,5,5,0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(widget.user.codename, style: TextStyle(color: LmmColors.lmmGold, fontFamily: "Top Secret", fontSize: 30),),
                          ],
                        ),
                      ),
                      

                      Container(
                        padding: EdgeInsets.fromLTRB(10,0,10,0),
                        child: Row(
                          children: <Widget>[

                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'),
                                  fit: BoxFit.fill
                                ),
                              ),
                              height: 35,
                              width: 35,
                            ),

                            Text(widget.user.sex.toUpperCase(), style: TextStyle(fontSize: 20, color: Colors.white)),
                            widget.user.membership.compareTo("basic")==0?
                            Container():
                            Expanded(
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10,0,10,0),
                                      margin: EdgeInsets.fromLTRB(2.5,0,2.5,0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/badge.png'),
                                          fit: BoxFit.fill
                                        ),
                                      ),
                                      height: 35,
                                      width: 24,
                                    ),
                                  ],
                                ),
                              ),    
                            )

                          ],
                        ),
                      ),

                      Divider(color: Colors.transparent, height: size.height*0.01,),

                      Container(
                        width: size.width*0.6,
                        child: Text(widget.user.summary, style: detailTextStyle),
                      ),
                      
                      Divider(color: Colors.transparent, height: size.height*0.01,),

                      //Page divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Container(
                            color: Colors.white,
                            child: SizedBox(
                              width: size.width*0.3,
                              height: 2,
                            ),
                          ),


                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'),
                                  fit: BoxFit.fill
                                ),
                              ),
                              height: 15,
                              width: 15,
                          ),


                          Container(
                            color: Colors.white,
                            child: SizedBox(
                              width: size.width*0.3,
                              height: 2,
                            ),
                          ),

                        ],
                      ),
                      
                      Container(
                        padding: EdgeInsets.fromLTRB(15,5,15,5),
                        child: Column(
                          children: [
                            Text(widget.user.email, style: detailTextStyle),
                            Text(widget.user.location, style: detailTextStyle,),
                            Text("${dobToAge(widget.user.dob)}", style: detailTextStyle),
                            Text(religionToText(widget.user.religion), style: detailTextStyle),
                            Text(widget.user.genotype.toUpperCase(), style: detailTextStyle),
                            Text(widget.user.education, style: detailTextStyle),
                            Text(widget.user.carrer, style: detailTextStyle),
                            Text(widget.user.stateOfOrigin, style: detailTextStyle),
                            Text(widget.user.maritalStatus, style: detailTextStyle),

                          ],
                        ),
                      ),

                      Divider(color: Colors.transparent, height: size.height*0.01,),
                      Divider(color: Colors.transparent, height: size.height*0.01,),
                      
                    ],
                  ),
      )
      );
    }

    String religionToText(String str){
      String result = "Others";
      if(str.compareTo("christian")==0){
        result = "Christian";
      }
      if(str.compareTo("muslim")==0){
        result = "Muslim";
      }

      return result;
    }

    int dobToAge(String dateStr){
      DateTime date = DateStringWrapper(dateStr).dartDateTime;
      int age = Age.dateDifference(toDate: DateTime.now(), fromDate:  date, includeToDate: false).years;
      return age;
    }

}