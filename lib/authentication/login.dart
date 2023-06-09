import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/authentication/auth_screen.dart';


import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    // see if email & password fields are filled out
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // attempt login
      loginUser();
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: "Please provide an email and a password.",);
        }
      );
    }
  }

  loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(message: "Authenticating user...",);
        }
    );

    User? currentUser;
    // check to see if current user exists in Firestore
    await firebaseAuth.signInWithEmailAndPassword(email: emailController.text.trim(),
        password: passwordController.text.trim())
    .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: error.message.toString(),);
          }
      );
    });
    // if user successfully authenticated, log user in and send rider to home screen
    if (currentUser != null) {
      // retrieve user Firebase data
      readDataAndSetDataLocally(currentUser!);
    }
  }

  // retrieve data from Firestore DB and set the data locally
  Future readDataAndSetDataLocally(User currentUser) async {
    // doc is for that specific user to login
    await FirebaseFirestore.instance.collection("riders").doc(currentUser.uid).get()
        .then((snapshot) async {
          // check to see if it's a seller id, as sellers cannot register as riders
          if (snapshot.exists)
            {
              await sharedPreferences!.setString("uid", currentUser.uid);
              await sharedPreferences!.setString("email", snapshot.data()!["riderEmail"]);
              // retrieve the rider name from the Firestore DB using the snapshot
              await sharedPreferences!.setString("name", snapshot.data()!["riderName"]);
              await sharedPreferences!.setString("photoUrl", snapshot.data()!["riderAvatarUrl"]);

              // send the logged in user to the home screen
              Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));

            }
          else {
            // sign out that person from rider app since record does not exist
            firebaseAuth.signOut();
            Navigator.pop(context);
            // send the not authenticated user to the auth screen
            Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));

            showDialog(
                context: context,
                builder: (c) {
                  return ErrorDialog(message: "No record exists for the provided user.");
                }
            );

          }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset("images/signup.png",
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObscure: true,
                ),
              ],
            )

          ),
          ElevatedButton(
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            onPressed: () {
              formValidation();
            },
          ),
        ],
      ),
    );
  }
}
