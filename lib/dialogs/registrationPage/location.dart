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
  String currentState = "Select a State";
  List<String> states = ["Abuja", "Abia", "Adamawa", "Akwa Ibom", "Anambra", "Bauchi", "Bayelsa", "Benue",
                          "Borno", "Cross River", "Delta", "Ebonyi", "Edo" "Ekiti", "Enugu", "Gombe", "Imo",
                          "Jigawa", "Kaduna", "Kano", "Katsina", "Kebbi", "Kogi", "Kwara", "Lagos", "Nassarawa",
                          "Niger", "Ogun", "Ondo", "Osun", "Oyo", "Plateau", "Rivers", "Sokoto", "Taraba", "Yobe",
                          "Zamfara"
                        ];

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
                width: widget.width,
                color: LmmColors.lmmGrey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                          color: LmmColors.lmmGrey,
                          child: Text("Location of Residence", style: TextStyle(
                            fontSize: 16
                          ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        currentState, style: TextStyle(
                          fontSize: 15
                        ),
                      ),  
                    )
                  ],
                )
              ),

              Divider(color: Colors.transparent, height: 5),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                InkWell(
                  child: Text("Select", style: TextStyle(fontSize: 18),),
                  onTap: (){
                    showPicker();
                  },
                ),

                VerticalDivider(color: Colors.transparent),

                Container(
                  height: 35,
                  width: 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/divider.png'),
                      fit: BoxFit.fill
                    ),
                  ),
                ),

                VerticalDivider(color: Colors.transparent),

                InkWell(
                  child: Text("Enter", style: TextStyle(fontSize: 18),),
                  onTap: (){
                    widget.resultCallBack(currentState);
                  },
                )

                ],
              ),

              Divider(color: Colors.transparent, height: 5 ),

            ],
          ),
        )
      ],
    );
  }
  
  showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: widget.width*0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/goldGradient.png'),
              fit: BoxFit.fill
            ),
          ),

          child: CupertinoPicker(
            onSelectedItemChanged: (value) {
              setState(() {
                currentState = states[value];
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