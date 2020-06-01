import 'package:flutter/material.dart';

class MaritalStatusDialog extends StatefulWidget {
  double width;
  Function(String status) resultCallBack;

  MaritalStatusDialog({
    @required this.width,
    @required this.resultCallBack
  });

  @override
  _MaritalStatusDialogState createState() => _MaritalStatusDialogState();
}

class _MaritalStatusDialogState extends State<MaritalStatusDialog> {
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
                    Text("Never Married"),
                  ],
                ),
                onTap: (){
                  widget.resultCallBack('never_married');
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
                    Text("Divorced"),
                  ],
                ),
                onTap: (){
                  widget.resultCallBack('divorced');
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
                    Text("Widowed"),
                  ],
                ),
                onTap: (){
                  widget.resultCallBack('widowed');
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