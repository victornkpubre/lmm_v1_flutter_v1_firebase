import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayerui/audioplayerui.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flauto.dart';
import 'package:flutter_sound/flutter_sound_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lagos_match_maker/apis/colors.dart';
import 'package:lagos_match_maker/apis/generic_database_manager.dart';
import 'package:lagos_match_maker/models/index.dart';
import 'package:lagos_match_maker/pages/premium_congrats_page.dart';
import 'package:lagos_match_maker/widgets/lmm_bottombar.dart';


class PremiumRegistrationPage extends StatefulWidget {

  User user;

  PremiumRegistrationPage({
    @required this.user
  });


  @override
  _PremiumRegistrationPageState createState() => _PremiumRegistrationPageState();
}

class _PremiumRegistrationPageState extends State<PremiumRegistrationPage> {
  //Image
  File image;

  // Recording ;
  FlutterSoundRecorder flutterSound =  new FlutterSoundRecorder();
  bool recording = false;
  bool playing = false;
  bool submitting = false;
  DateTime startTime;
  DateTime endTime;
  

  TextEditingController voiceController = TextEditingController();
  final player = AudioPlayer();



  @override
  void initState() {
    initPlayer();
    super.initState();
  }


  initPlayer() async {
    
  }



  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    

    return Container(
      child: Scaffold(

        bottomSheet: LmmBottomBar(),

        body: Container(
          height: size.height,
          color: Colors.black,
          
          child: submitting?
          Center(
            child: CircularProgressIndicator(backgroundColor: LmmColors.lmmGold),
          ):
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              InkWell(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text("Click to Upload a Picture", style: TextStyle(color: LmmColors.lmmGold),),
                ),
                onTap: (){
                  //Pick Image
                  pickImage();

                },
              ),

              InkWell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: LmmColors.lmmGrey,
                  child: Container(
                    width: size.width*0.4,
                    height: size.width*0.4,
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Center(
                      child: image == null?
                      Icon(Icons.camera_alt, color: LmmColors.lmmGrey, size: size.width*0.3,):
                      Image.file(image, fit: BoxFit.fill),
                    )
                  )
                ),
                onTap: (){
                  //Pick Image
                  pickImage();

                },
              ),

              Divider(color: Colors.transparent, height: size.height*0.01,),

              Container(
                color: LmmColors.lmmGold,
                child: SizedBox(
                  width: size.width*0.5,
                  height: 2,
                ),
              ),

              //Voice Recorder Section
              Container(
                width: size.width*0.5,
                padding: EdgeInsets.all(5),
                child: Text("Describe the type of person you want to meet in less than 2 mins", style: TextStyle(color: LmmColors.lmmGold, fontSize: 12)),
              ),

              Divider(color: Colors.transparent, height: size.height*0.025,),

              InkWell(
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: LmmColors.lmmGrey,
                    shape: BoxShape.circle
                  ),

                  child: Icon(Icons.mic, size: 50, color: recording? Colors.red: Colors.white,),
                  
                ),
                onTap: (){

                  //Record
                  if(!recording){
                    startRecording();
                  }else{
                    stopRecording();
                  }

                  //Change state
                  setState(() {
                    recording = !recording;
                  });

                },
              ),

              Divider(color: Colors.transparent, height: size.height*0.01,),

              //Voice Player
              Visibility(
                visible: endTime != null,
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15,5,15,25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        InkWell(
                          child: playing? Icon(Icons.pause, size: 30, color: LmmColors.lmmGold): Icon(Icons.play_arrow, size: 30, color: LmmColors.lmmGold),
                          onTap: () async {
                            await player.setUrl(voiceController.text);

                            if(playing){
                              setState(() {
                                playing = false;
                              });
                              
                              player.stop();
                            }else{
                              setState(() {
                                playing = true;
                              });
                              
                              player.play();
                            }

                          },
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(5,0,5,0),
                          color: LmmColors.lmmGold,
                          child: SizedBox(
                            height: 25, 
                            width: 1,
                          ),
                        ),

                        InkWell(
                          child: Icon(Icons.stop, size: 30, color: LmmColors.lmmGold),
                          onTap: (){
                            if(playing){
                               setState(() {
                                playing = false;
                                player.stop();
                              });
                            }
                          },
                        ),

                      ],
                    ),
                  ),
                )
              ),

              Divider(color: Colors.transparent, height: size.height*0.01,),


              //Btn
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
                      child: Text("Submit",  
                        style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                      ),
                    )
                ),
                onTap: (){

                  if(validate()){
                    submit();
                  }else{
                    //Toast
                    Fluttertoast.showToast(
                      msg: "Make sure you pick a Image and record your description",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: LmmColors.lmmGrey,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                  }

                },
              )
            ],
            
          )
        )
      )
    );
  }

  Future<void> submit() async {

    setState(() {
      submitting = true;
    });

    //Change user membership to basic - pending approval
    widget.user.membership = "basic";

    //Send Verification Request
    sendVerificationRequest(widget.user);


    //Upload Premium User image and voice_note
    //Image
    String name = "${widget.user.uid}_image";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("$name.jpg");
    firebaseStorageRef.putFile(image);
    String url = await firebaseStorageRef.getDownloadURL(); 
    widget.user.pictureUrl = url;

    //Voice  
    String voice_name = "${widget.user.uid}_voice";
    StorageReference voice_firebaseStorageRef = FirebaseStorage.instance.ref().child("$voice_name${flutterSound.fileExtension(voiceController.text)}");
    voice_firebaseStorageRef.putFile(File(voiceController.text),
      StorageMetadata(
        contentType: 'audio/aac',
        customMetadata: <String, String>{'file': 'audio'},
      ),
    );
    String voice_url = await firebaseStorageRef.getDownloadURL(); 
    widget.user.voiceUrl = voice_url;



    //Upload Basic User to Database
    String jsonInput = json.encode(widget.user);
    FirebaseRealtimeDatabaseManager().createWithUid(jsonInput, "user");


    //Navigate
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PremiumCongratsPage(user: widget.user,)),
    );

  }

  void sendVerificationRequest(User user){
    FirebaseRealtimeDatabaseManager().addToStringTable("premium_request", user.uid);
  }


  bool validate(){
    if(voiceController.text != null && image != null){
      return true;
    }else{
      return false;
    }
  }

  pickImage() async {
    File file = await ImagePicker.pickImage( source: ImageSource.gallery);
    setState(() {
      if(file != null){
        image = file;
      }
    });
  }

  Future<void> startRecording() async {
    startTime = DateTime.now();
    setState(() {
      if(endTime != null) { endTime = null; }
    });
    await flutterSound.initialize().then((recorder){
      recorder.startRecorder();
    });
  }

  Future<void> stopRecording() async {
    endTime = DateTime.now();
    voiceController.text = await flutterSound.stopRecorder();
    await flutterSound.defaultPath(t_CODEC.CODEC_AAC).then((value){
      voiceController.text = value;
    });
  }

}