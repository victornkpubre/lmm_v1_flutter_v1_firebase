import 'package:flutter/material.dart';


class ReligionDialog extends StatefulWidget {

  double width;
  Function(String status) resultCallBack;

  ReligionDialog({
    @required this.width,
    @required this.resultCallBack
  });

  @override
  _ReligionDialogState createState() => _ReligionDialogState();
}

class _ReligionDialogState extends State<ReligionDialog> {
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

              Divider(color: Colors.transparent),

              
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Muslim"),
                  ],
                ),
                onTap: (){
                  widget.resultCallBack('muslim');
                },
              ),

              Divider(color: Colors.transparent),

              Container(
                height: 3,
                width: widget.width*0.9,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/divider.png'),
                    fit: BoxFit.fill
                  ),
                ),
              ),

              Divider(color: Colors.transparent),

              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Christian"),
                  ],
                ),
                onTap: (){
                  widget.resultCallBack('christian');
                },
              ),

              Divider(color: Colors.transparent),


              Container(
                height: 3,
                width: widget.width*0.9,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/divider.png'),
                    fit: BoxFit.fill
                  ),
                ),
              ),

              Divider(color: Colors.transparent),

              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Others"),
                  ],
                ),
                onTap: (){
                  widget.resultCallBack('others');
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