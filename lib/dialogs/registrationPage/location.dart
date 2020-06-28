import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';

class LocationDialog extends StatefulWidget {
  double width;
  Function(String state) resultCallBack;

  LocationDialog({
    @required this.width,
    @required this.resultCallBack
  });
  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  TextEditingController controller = TextEditingController();
  // String currentState = "Select a State";
  // List<String> states = ["Abuja", "Abia", "Adamawa", "Akwa Ibom", "Anambra", "Bauchi", "Bayelsa", "Benue",
  //                         "Borno", "Cross River", "Delta", "Ebonyi", "Edo" "Ekiti", "Enugu", "Gombe", "Imo",
  //                         "Jigawa", "Kaduna", "Kano", "Katsina", "Kebbi", "Kogi", "Kwara", "Lagos", "Nassarawa",
  //                         "Niger", "Ogun", "Ondo", "Osun", "Oyo", "Plateau", "Rivers", "Sokoto", "Taraba", "Yobe",
  //                         "Zamfara"
  //                       ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
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
          width: widget.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

              Container(
                height: 3 * 18.0,
                child: TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Location of Residence",
                    fillColor: LmmColors.lmmGrey,
                    filled: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),

              Divider(color: Colors.transparent),

              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Text("Enter", style: TextStyle(fontSize: 18),)

                  ],
                ),
                onTap: (){
                  widget.resultCallBack(controller.text);
                },
              ),

              Divider(color: Colors.transparent),

            ],
          ),
        )
      ],
    );
  }
  
  // showPicker() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: widget.width*0.5,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage('assets/images/goldGradient.png'),
  //             fit: BoxFit.fill
  //           ),
  //         ),

  //         child: CupertinoPicker(
  //           onSelectedItemChanged: (value) {
  //             setState(() {
  //               currentState = states[value];
  //             });
  //           },
  //           itemExtent: 30.0,
  //           children: states.map((state)=> Text(state, style: TextStyle(fontSize: 15),)).toList()
  //         ),
  //       );
  //     }
  //   );
  // }
}