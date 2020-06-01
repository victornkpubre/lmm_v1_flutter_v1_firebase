import 'package:flutter/material.dart';
import 'package:lagos_match_maker/apis/colors.dart';


class EducationDialog extends StatefulWidget {
  double width;
  Function(String text) resultCallBack;

  EducationDialog({
    @required this.width,
    @required this.resultCallBack
  });

  @override
  _EducationDialogState createState() => _EducationDialogState();
}

class _EducationDialogState extends State<EducationDialog> {
  TextEditingController controller = TextEditingController();


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
                height: 10 * 18.0,
                child: TextField(
                  controller: controller,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: "College, university or high school",
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
}