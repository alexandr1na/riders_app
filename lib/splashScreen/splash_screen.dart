import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riders_app/global/global.dart';

import '../authentication/auth_screen.dart';
import '../mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTimer()
  {
    Timer(const Duration(seconds: 2), () async {
      // need to create instance of our current firebase user
      // if user is already logged in
      if(firebaseAuth.currentUser != null) {
        // logged in, push to homepage
        Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
      else {
        // if not logged in, go to login screen
        Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("images/logo.png"),
              ),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Deliver Online Food Orders!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              )
            ],
          )
        )
      )
    );
  }
}
