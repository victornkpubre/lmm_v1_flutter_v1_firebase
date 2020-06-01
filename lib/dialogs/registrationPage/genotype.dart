import 'package:flutter/material.dart';

class GenotypeDialog extends StatefulWidget {
  double width;
  Function(String status) resultCallBack;

  GenotypeDialog({
    @required this.width,
    @required this.resultCallBack
  });

  @override
  _GenotypeDialogState createState() => _GenotypeDialogState();
}

class _GenotypeDialogState extends State<GenotypeDialog> {
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
                    Text("AA"),
                  ],
                ),
                onTap: (){
                  widget.resultCallBack('aa');
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
                    Text("AS"),
                  ],
                ),
                onTap: (){
                  widget.resultCallBack('as');
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
                    Text("SS"),
                  ],
                ),
                onTap: (){
                  widget.resultCallBack('ss');
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