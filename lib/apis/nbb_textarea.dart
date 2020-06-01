import 'package:flutter/material.dart';

class TextArea extends StatelessWidget {
  TextEditingController controller;
  double height;
  double width;
  int maxLines;
  int maxLength;
  String hintText;
  FocusNode node;

  bool border;
  Color color;

  TextArea({
    @required this.controller,
    @required this.height,
    @required this.color,
    @required this.border,
    this.width,
    this.maxLines,
    this.maxLength,
    this.hintText,
    this.node
    
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width!=null? width: 0,
      color: Colors.transparent,
      //padding: EdgeInsets.all(5.0),
      child: new ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: height,
        ),
        child: new Scrollbar(
          child: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            //reverse: true,
            child: SizedBox(
              height: height,
              child: new TextField(
                controller: controller,
                focusNode: node,
                maxLines: maxLines,
                maxLength: maxLength,
                style: TextStyle(fontSize: 15, fontFamily: 'Times New Roman'),
                decoration: !border?
                InputDecoration(
                  fillColor: color,
                  filled: true,
                  border: InputBorder.none,
                  hintText: hintText,
                  
                ):
                InputDecoration(
                  fillColor: color,
                  filled: true,
                  hintText: hintText,
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}