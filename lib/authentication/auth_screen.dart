import 'package:flutter/material.dart';
import 'package:riders_app/authentication/login.dart';
import 'package:riders_app/authentication/register.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.blue,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text("PandaRiders",
        style: TextStyle(
          fontSize: 60,
          color: Colors.white,
          fontFamily: "Signatra",
          letterSpacing: 6
        ),
        ),
        centerTitle: true,
        bottom: const TabBar(tabs: [
          Tab(
            icon: Icon(Icons.lock, color: Colors.white,),
            text: "Login",
          ),
          Tab(
            icon: Icon(Icons.person, color: Colors.white),
            text: "Register",
          )
        ],
        indicatorColor: Colors.white38,
        indicatorWeight: 6,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.brown,
              Colors.purple,
            ]
          )
        ),
        child: const TabBarView(
          children: [
            LoginScreen(),
            RegisterScreen(),
          ],
        ),
      ),
    )
    );
  }
}
