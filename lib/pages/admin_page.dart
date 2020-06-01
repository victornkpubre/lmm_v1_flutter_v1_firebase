
import 'package:flutter/material.dart';
import 'package:lagos_match_maker/pages/admin_pages/home_page.dart';



class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container( 
          color: Colors.black,
          height: size.height,
          child: Center(child: SingleChildScrollView( child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              //Logo Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill
                          ),
                        ),
                        height: 70,
                        width: 70,
                      ),

                      Container(
                        width: size.width*0.8,
                        height: size.width*0.8*0.25,
                        child: Image.asset('assets/images/logoTitle.png',),
                      )
                    ],
                  ),

                ], 
              ),

              Container(
                width: size.width*0.7,
                child: Column(
                  children: [
                    //Email
                    Container(
                      child: TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        
                      ),
                    ),
                    Divider(color: Colors.white, height: 0, thickness: 3 ),

                    Divider(color: Colors.transparent),

                    //Password
                    Container(
                      child: TextField(
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        
                      ),
                    ),
                    Divider(color: Colors.white, height: 0, thickness: 3, ),

                    Divider(color: Colors.transparent),
                  ],
                ),
              ),

              Divider(color: Colors.transparent),
              Divider(color: Colors.transparent),


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
                    child: Text("Login",  
                      style: TextStyle(fontSize: 18, fontFamily: "Times New Roman"),
                    ),
                  )
                ),
                onTap: (){

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHomePage())
                  );

                },
              )

            ],
          )

        ),
      )
      
    )));
  }
}