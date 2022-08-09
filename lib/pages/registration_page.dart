import 'dart:convert';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/date_string_wrapper.dart';
import 'package:lagos_match_maker/apis/generic_database_manager.dart';
import 'package:lagos_match_maker/apis/lmm_shared_preference_manager.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/career.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/dateOfBirth.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/education.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/gender.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/genotype.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/location.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/maritalStatus.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/phoneNumber.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/religion.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/state_of_origin.dart';
import 'package:lagos_match_maker/dialogs/registrationPage/summary.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/basic_congrats_page.dart';
import 'package:lagos_match_maker/pages/premium_registeration_page.dart';
import 'package:lagos_match_maker/widgets/lmm_bottombar.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class RegistrationPage extends StatefulWidget {
  User user;

  RegistrationPage({@required this.user});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  Size size;
  bool submitting = false;

  int currentStage = 0;
  //List<Widget> dialogs;
  Widget currentDialog;
  Widget initDialog;
  double dialogScreenHeight;

  //Animation Variables
  AnimatorKey animatorKey = AnimatorKey<double>();

  List<String> codeNames = [];

  @override
  void initState() {
    // dialogs = loadDialog();
    loadData();
    super.initState();
  }

  loadData(){
    //codeNames = FirebaseRealtimeDatabaseManager().readAtrributebyUid(table, attribute, uid)
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    dialogScreenHeight = size.height * 0.6;

    initDialog = GenderDialog(
        width: size.width * 0.7,
        resultCallBack: (result) {
          genderCallBackFunction(result);
        });

    return Container(
      color: Colors.black,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomSheet: LmmBottomBar(),
        body: Container(
          color: Colors.black,
          child: codeNames.isEmpty
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.arrow_back_ios,
                                color: LmmColors.lmmGold),
                          ),
                          onTap: () {
                            if (currentStage != 0) {
                              setState(() {
                                --currentStage;
                                nextDialog();
                              });
                            }
                          },
                        )
                      ],
                    ),
                    Divider(color: Colors.transparent),
                    SizedBox(
                        height: dialogScreenHeight,
                        width: size.width,
                        child: submitting
                            ? Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: LmmColors.lmmGold),
                              )
                            : Center(
                                child: Animator<double>(
                                animatorKey: animatorKey,
                                tween: Tween<double>(begin: 1, end: 0),
                                duration: Duration(milliseconds: 200),
                                builder: (context, animatorState, child) =>
                                    Center(
                                        child: Opacity(
                                            opacity: animatorState.value,
                                            child: currentDialog == null
                                                ? initDialog
                                                : currentDialog)),
                                endAnimationListener: (animatorState) {
                                  //case - start next animation - change currentDialog based on states and currentStage
                                  nextDialog();
                                },
                              ))),
                  ],
                ),
        ),
      ),
    );
  }

  nextDialog() {
    //change currentDialog based on states and currentStage
    //Fade In - reverse
    switch (currentStage) {
      case 0:
        currentDialog = GenderDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              genderCallBackFunction(result);
            });
        break;
      case 1:
        currentDialog = MaritalStatusDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              maritalStatusCallBackFunction(result);
            });
        break;
      case 2:
        currentDialog = GenotypeDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              genotypeCallBackFunction(result);
            });
        break;
      case 3:
        currentDialog = ReligionDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              religionCallBackFunction(result);
            });
        break;
      case 4:
        currentDialog = StateOfOriginDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              stateOfOriginCallBackFunction(result);
            });
        break;
      case 5:
        currentDialog = DateOfBirthDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              dobCallBackFunction(result);
            });
        break;
      case 6:
        currentDialog = LocationDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              locationCallBackFunction(result);
            });
        break;
      case 7:
        currentDialog = PhoneNumberDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              phoneCallBackFunction(result);
            });
        break;
      case 8:
        currentDialog = CareerDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              careerCallBackFunction(result);
            });
        break;
      case 9:
        currentDialog = EducationDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              educationCallBackFunction(result);
            });
        break;
      case 10:
        currentDialog = SummaryDialog(
            width: size.width * 0.7,
            resultCallBack: (result) {
              summaryCallBackFunction(result);
            });
        break;
      default:
    }

    animatorKey.controller.reverse();
  }

  //Functions
  genderCallBackFunction(String gender) {
    widget.user.sex = gender;
    currentStage = 1;
    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.sex);
  }

  maritalStatusCallBackFunction(String status) {
    widget.user.maritalStatus = status;
    currentStage = 2;

    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.maritalStatus);
  }

  genotypeCallBackFunction(String type) {
    widget.user.genotype = type;
    currentStage = 3;

    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.genotype);
  }

  religionCallBackFunction(String result) {
    widget.user.religion = result;
    currentStage = 4;

    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.religion);
  }

  stateOfOriginCallBackFunction(String state) {
    widget.user.stateOfOrigin = state;
    currentStage = 5;

    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.stateOfOrigin);
  }

  dobCallBackFunction(DateTime date) {
    widget.user.dob =
        DateStringWrapper.withDate(date).convertToJsonString(date);
    currentStage = 6;

    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.dob);
  }

  locationCallBackFunction(String state) {
    widget.user.location = state;
    currentStage = 7;

    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.location);
  }

  phoneCallBackFunction(String number) {
    widget.user.phoneNumber = number;
    currentStage = 8;

    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.phoneNumber);
  }

  careerCallBackFunction(String text) {
    widget.user.carrer = text;
    currentStage = 9;

    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.carrer);
  }

  educationCallBackFunction(String text) {
    widget.user.education = text;
    currentStage = 10;

    //Fade Out GenderDialog
    animatorKey.triggerAnimation();

    print(widget.user.education);
  }

  summaryCallBackFunction(String text) async {
    if (!submitting) {
      setState(() {
        submitting = true;
      });

      widget.user.summary = text;
      currentStage = 11;

      //Fade Out GenderDialog
      //animatorKey.triggerAnimation();

      //print(widget.user.summary);

      widget.user.matches = [];
      widget.user.codename = await generateCodeName();

      //login locally
      LmmSharedPreferenceManager()
          .loginUser(widget.user.email, widget.user.password, widget.user.uid);

      //End of Basic Registration
      if (widget.user.membership.compareTo("basic") == 0) {
        //Upload Basic User to Database
        String jsonInput = json.encode(widget.user);
        FirebaseRealtimeDatabaseManager().createWithUid(jsonInput, "user");

        //Navigate
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BasicCongratsPage(
                    user: widget.user,
                  )),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PremiumRegistrationPage(user: widget.user)),
        );
      }
    }
  }

  Future<String> generateCodeName() async {
    bool success = false;
    String codename;
    List<String> list;

    //get list of codenames
    list = await getCodeNames();

    while (!success) {
      codename = "${randomAlpha(2)}${randomBetween(10, 1000)}";
      print(codename);
      if (!isTaken(list, codename)) {
        success = true;
      }
    }

    return codename;
  }

  Future<List<String>> getCodeNames() async {
    if (await FirebaseRealtimeDatabaseManager().tableExists("user")) {
      List<dynamic> users =
          json.decode(await FirebaseRealtimeDatabaseManager().readAll("user"));
      List<String> names = [];

      //FirebaseRealtimeDatabaseManager()..readByAttrWithId(table, attribute, attribute_value)

      users.forEach((element) {
        User user = User.fromJson(element);
        names.add(user.codename);
      });
      return names;
    } else {
      return [];
    }
  }

  bool isTaken(List list, String name) {
    bool result = false;
    list.forEach((element) {
      if ((element as String).compareTo(name) == 0) {
        result = true;
      }
    });
    return result;
  }
}
