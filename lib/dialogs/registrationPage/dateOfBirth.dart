import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';

class DateOfBirthDialog extends StatefulWidget {
  double width;
  Function(DateTime dateTime) resultCallBack;

  DateOfBirthDialog({
    @required this.width,
    @required this.resultCallBack
  });


  @override
  _DateOfBirthDialogState createState() => _DateOfBirthDialogState();
}

class _DateOfBirthDialogState extends State<DateOfBirthDialog> {
  DateTime currentDate = DateTime.now();
  List<String> months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "July", "Aug", "Sept", "Oct", "Nov", "Dec"];

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
                padding: EdgeInsets.all(10),
                color: LmmColors.lmmGrey,
                child: Center(
                  child: Text(
                    "${months[currentDate.month]} ${currentDate.day} ${currentDate.year}",
                    style: TextStyle(fontSize: 18),
                  ),
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
                    widget.resultCallBack(currentDate);
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

            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newdate) {
                //DateTime newdate = DateTime(result.year, result.month - 1, result.day, result.hour);
                setState(() {
                  currentDate = newdate;
                  //print(currentDate.month);
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
}