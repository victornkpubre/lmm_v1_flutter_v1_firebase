import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/date_string_wrapper.dart';
import 'package:lagos_match_maker/apis/generic_database_manager.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/premium_registeration_page.dart';
import 'package:lagos_match_maker/splash_screen.dart';
import 'package:lagos_match_maker/widgets/lmm_appbar.dart';
import 'package:lagos_match_maker/widgets/lmm_bottombar.dart';

class ProfilePage extends StatefulWidget {
  User user;

  ProfilePage({
    this.user
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Size size;
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "July", "Aug", "Sept", "Oct", "Nov", "Dec"];
  List<String> states = ["Abuja", "Abia", "Adamawa", "Akwa Ibom", "Anambra", "Bauchi", "Bayelsa", "Benue",
                          "Borno", "Cross River", "Delta", "Ebonyi", "Edo" "Ekiti", "Enugu", "Gombe", "Imo",
                          "Jigawa", "Kaduna", "Kano", "Katsina", "Kebbi", "Kogi", "Kwara", "Lagos", "Nassarawa",
                          "Niger", "Ogun", "Ondo", "Osun", "Oyo", "Plateau", "Rivers", "Sokoto", "Taraba", "Yobe",
                          "Zamfara"
                        ];

  TextEditingController summaryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController careerController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController stateOfOriginController = TextEditingController();


  @override
  void initState() {
    if(widget.user != null){
      summaryController.text = widget.user.summary;
      educationController.text = widget.user.education;
      careerController.text = widget.user.carrer;
      locationController.text = widget.user.location;
      stateOfOriginController.text = widget.user.stateOfOrigin;
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    TextStyle detailsStyle = TextStyle(color: LmmColors.lmmGold, fontSize: 16, fontFamily: "Times New Roman");
    TextStyle titleStyle = TextStyle(color: LmmColors.lmmGold, fontSize: 20, fontFamily: "Times New Roman");
    


    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          title: LmmAppBar(user: widget.user),
        ),

        bottomSheet: LmmBottomBar(user: widget.user),

        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(0,0,0,size.width*0.1),
            padding: EdgeInsets.all(size.width*0.1),
            color: Colors.black,
            //height: size.height*0.8,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                //Membership
                InkWell(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        widget.user.membership.compareTo("basic")==0?
                        Text("Membership\n Basic", style: titleStyle,):
                        Text("Membership\n Premium", style: titleStyle,)
                      ]
                    ),
                  ),
                  onTap: (){
                    //if basic request upgrade
                    if(widget.user.membership.compareTo("basic")==0){
                      requestUpgrade();
                    }
                  },
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      widget.user.membership.compareTo("basic")==0?
                      Text("Click to Upgrade", style: detailsStyle,):
                      Container(),
                    ],
                  ),
                  onTap: (){
                    //if basic request upgrade
                    if(widget.user.membership.compareTo("basic")==0){
                      requestUpgrade();
                    }
                  },
                ),


                //Codename
                Text("CodeName", style: titleStyle,),
                Row(
                  children: <Widget>[
                    Text("${widget.user.codename.toUpperCase()}", style: TextStyle(color: LmmColors.lmmGold, fontSize: 16, fontFamily: "Times New Roman"))
                  ]
                ),
                Divider(color: Colors.transparent,),


                //Email
                Text("Email", style: titleStyle,),
                Row(
                  children: <Widget>[
                    Text(widget.user.email, style: detailsStyle)
                  ],
                ),
                Divider(color: Colors.transparent,),


                //Phone number
                Text("Phone number", style: titleStyle,),
                Row(
                  children: <Widget>[
                    Text(widget.user.phoneNumber, style: detailsStyle,)
                  ],
                ),
                Divider(color: Colors.transparent,),


                //Summary
                Text("Summary", style: titleStyle,),
                Row(
                  children: <Widget>[
                    Container(
                      height: 7 * 18.0,
                      width: size.width*0.8,
                      decoration: BoxDecoration(
                        color: LmmColors.lmmDarkGrey,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: TextField(
                        controller: summaryController,
                        maxLines:  7,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      )
                    )
                  ],
                ),
                InkWell(
                  child: Container(
                    height: 30,
                    width: size.width*0.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/goldGradient.png'),
                        fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                    ),
                    child: Center(child: Text("Change"),)
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "summary", summaryController.text);
                  },
                ),
                Divider(color: Colors.transparent,),


                //Education
                Text("Education", style: titleStyle,),
                Row(
                  children: <Widget>[
                    Container(
                      height: 3 * 18.0,
                      width: size.width*0.8,
                      decoration: BoxDecoration(
                        color: LmmColors.lmmDarkGrey,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: TextField(
                        controller: educationController,
                        maxLines:  3,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      )
                    )
                  ],
                ),
                InkWell(
                  child: Container(
                    height: 30,
                    width: size.width*0.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/goldGradient.png'),
                        fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                    ),
                    child: Center(child: Text("Change"),)
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "education", educationController.text);
                  },
                ),
                Divider(color: Colors.transparent,),



                //Career
                Text("Career", style: titleStyle,),
                Row(
                  children: <Widget>[
                    Container(
                      height: 3 * 18.0,
                      width: size.width*0.8,
                      decoration: BoxDecoration(
                        color: LmmColors.lmmDarkGrey,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: TextField(
                        controller: careerController,
                        maxLines:  3,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      )
                    )
                  ],
                ),
                InkWell(
                  child: Container(
                    height: 30,
                    width: size.width*0.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/goldGradient.png'),
                        fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                    ),
                    child: Center(child: Text("Change"),)
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "career", careerController.text);
                  },
                ),
                Divider(color: Colors.transparent,),



                //Location
                Text("Location", style: titleStyle,),
                Row(
                  children: <Widget>[
                    Container(
                      height: 3 * 18.0,
                      width: size.width*0.8,
                      decoration: BoxDecoration(
                        color: LmmColors.lmmDarkGrey,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: TextField(
                        controller: locationController,
                        maxLines:  3,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      )
                    )
                  ],
                ),
                InkWell(
                  child: Container(
                    height: 30,
                    width: size.width*0.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/goldGradient.png'),
                        fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                    ),
                    child: Center(child: Text("Change"),)
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "location", locationController.text);
                  },
                ),
                Divider(color: Colors.transparent,),

                //State of Origin
                Text("State of Origin", style: titleStyle,),
                Row(
                  children: <Widget>[
                    Container(
                      height: 3 * 18.0,
                      width: size.width*0.8,
                      decoration: BoxDecoration(
                        color: LmmColors.lmmDarkGrey,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: TextField(
                        controller: locationController,
                        maxLines:  3,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      )
                    )
                  ],
                ),
                InkWell(
                  child: Container(
                    height: 30,
                    width: size.width*0.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/goldGradient.png'),
                        fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                    ),
                    child: Center(child: Text("Change"),)
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "stateOfOrigin", stateOfOriginController.text);
                  },
                ),
                Divider(color: Colors.transparent,),


                //Dob
                InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Date of Birth", style: titleStyle,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${months[DateStringWrapper(widget.user.dob).dartDateTime.month-1]} ${DateStringWrapper(widget.user.dob).dartDateTime.day} ${DateStringWrapper(widget.user.dob).dartDateTime.year}",
                            style: detailsStyle,
                          ),
                          Icon(Icons.keyboard_arrow_down, size: 25, color: LmmColors.lmmGold,)
                        ],
                      ),
                      Divider(color: LmmColors.lmmGold, height: 2,),
                    ],
                  ),
                  onTap: (){
                    showDatePicker(context);
                  },
                ),
                Divider(color: Colors.transparent,),
                Divider(color: Colors.transparent,),

                //Sex
                Text("Sex", style: titleStyle,),
                //Male
                InkWell(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("Male",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.sex.compareTo("male")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "sex", "male");
                    setState(() {
                      widget.user.sex = "male";
                    });
                  },
                ),

                Divider(color: Colors.transparent),

                //Female
                InkWell(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("Female",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),
                      
                      widget.user.sex.compareTo("female")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "sex", "female");
                    setState(() {
                      widget.user.sex = "female";
                    });
                  },
                ),


                Divider(color: Colors.transparent),
                Divider(color: Colors.transparent),


                //Religion
                Text("Religion", style: titleStyle,),
                //Muslim
                InkWell(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("Muslim",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.religion.compareTo("muslim")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "religion", "muslim");
                    setState(() {
                      widget.user.religion = "muslim";
                    });
                  },
                ),

                Divider(color: Colors.transparent),

                //Christian
                InkWell(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("Christian",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.religion.compareTo("christian")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),
                      

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "religion", "christian");
                    setState(() {
                      widget.user.religion = "christian";
                    });
                  },
                ),

                Divider(color: Colors.transparent),

                //Others
                InkWell(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("Others",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.religion.compareTo("others")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),
                      

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "religion", "others");
                    setState(() {
                      widget.user.religion = "others";
                    });
                  },
                ),


                Divider(color: Colors.transparent),
                Divider(color: Colors.transparent),


                //Genotype
                Text("Genotype", style: titleStyle,),
                //AA
                InkWell(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("AA",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.genotype.compareTo("aa")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "genotype", "aa");
                    setState(() {
                      widget.user.genotype = "aa";
                    });
                  },
                ),

                Divider(color: Colors.transparent),

                //AS
                InkWell(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("AS",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.genotype.compareTo("as")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),
                      

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "genotype", "as");
                    setState(() {
                      widget.user.genotype = "as";
                    });
                  },
                ),

                Divider(color: Colors.transparent),

                //SS
                InkWell(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("SS",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.genotype.compareTo("ss")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),
                      

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "genotype", "ss");
                    setState(() {
                      widget.user.genotype = "ss";
                    });
                  },
                ),


                Divider(color: Colors.transparent),
                Divider(color: Colors.transparent),


                //Maritial Status
                Text("Maritial Status", style: titleStyle,),
                //Never Married
                InkWell(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("Never Married",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.maritalStatus.compareTo("never_married")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "maritalStatus", "never_married");
                    setState(() {
                      widget.user.maritalStatus = "never_married";
                    });
                  },
                ),

                Divider(color: Colors.transparent),

                //Divorced
                InkWell(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("Divorced",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.maritalStatus.compareTo("divorced")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),
                      

                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "maritalStatus", "divorced");
                    setState(() {
                      widget.user.maritalStatus = "divorced";
                    });
                  },
                ),

                Divider(color: Colors.transparent),

                //Widowed
                InkWell(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: size.width*0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/goldGradient.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Text("Widowed",
                              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                            ),
                          ),
                        )
                      ),

                      widget.user.maritalStatus.compareTo("widowed")==0?
                      Container():
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromRGBO(80, 80, 80, 0.75),
                        ),
                        child: SizedBox(
                          width: size.width*0.8,
                          height: 35,
                        ),
                      ),
                      
                    ]
                  ),
                  onTap: (){
                    FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "maritalStatus", "widowed");
                    setState(() {
                      widget.user.maritalStatus = "widowed";
                    });
                  },
                ),


                Divider(color: Colors.transparent),
                Divider(color: Colors.transparent),
                Divider(color: Colors.transparent),

                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Log Out", style: TextStyle(color: LmmColors.lmmGold, fontSize: 30, fontFamily: "Times New Roman"),),
                    ],
                  ),
                  onTap: () async {
                    //Log Out 
                    
                    //Logout Locally
                    await LmmSharedPreferenceManager().logoutUser();

                    //Pop all routes
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    //Open Splash Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                    );

                  },
                ),


                Divider(color: Colors.transparent),
                


              ],
            ),
          )
        )

    );
    
  }

  requestUpgrade(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PremiumRegistrationPage(user: widget.user)),
    );
  }


  showDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          size = MediaQuery.of(context).size;
          return Container(
            height: size.width*0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/goldGradient.png'),
                fit: BoxFit.fill
              ),
            ),

            child: CupertinoDatePicker(
              initialDateTime: DateStringWrapper(widget.user.dob).dartDateTime,
              onDateTimeChanged: (DateTime newdate) {
                //DateTime newdate = DateTime(result.year, result.month - 1, result.day, result.hour);
                String date = DateStringWrapper.withDate(newdate).jsonDateTime;
                print(widget.user.dob);
                FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "dob", date);
                setState(() {
                  widget.user.dob =  date;
                });
              },
              use24hFormat: true,
              maximumDate: new DateTime(2022, 1, 1),
              minimumYear: 1940,
              maximumYear: 2022,
              minuteInterval: 1,
              mode: CupertinoDatePickerMode.date,
            )
          );
        });
  }


  showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        size = MediaQuery.of(context).size;
        return Container(
          height: size.width*0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/goldGradient.png'),
              fit: BoxFit.fill
            ),
          ),

          child: CupertinoPicker(
            onSelectedItemChanged: (value) {
              FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "location", states[value]);
              setState(() {
                widget.user.location =  states[value];
              });
            },
            itemExtent: 30.0,
            children: states.map((state)=> Text(state, style: TextStyle(fontSize: 15),)).toList()
          ),
        );
      }
    );
  }

  showStateOfOriginPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        size = MediaQuery.of(context).size;
        return Container(
          height: size.width*0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/goldGradient.png'),
              fit: BoxFit.fill
            ),
          ),

          child: CupertinoPicker(
            onSelectedItemChanged: (value) {
              FirebaseRealtimeDatabaseManager().updateWIthUid("user", widget.user.uid, "stateOfOrigin", states[value]);
              setState(() {
                widget.user.stateOfOrigin =  states[value];
              });
            },
            itemExtent: 30.0,
            children: states.map((state)=> Text(state, style: TextStyle(fontSize: 15),)).toList()
          ),
        );
      }
    );
  }

}