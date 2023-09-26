import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder_app/pages/front_page/resusables/reusable_widgets.dart';
import 'package:medicine_reminder_app/pages/front_page/sign_up_page.dart';
import 'package:medicine_reminder_app/pages/home_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
          // Color(0xFFFF9B8E), // Light Coral
          // Color(0xFFFF6B6B), // Light Salmon
          Color(0xff1f005c),
          Color(0xff5b0060),
          Color(0xff870160),
          Color(0xffac255e),
          Color(0xffca485c),
          Color(0xffe16b5c),
          Color(0xfff39060),
          Color(0xffffb56b),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/logo/heartbeat.png"),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter email", Icons.person_outline, false,
                    _emailTextController),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter password", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    const snackBar = SnackBar(
                        content: Text('You are logged in'),
                        duration: Duration(milliseconds: 5000),
                        backgroundColor: Color.fromARGB(255, 89, 193, 189));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }).onError((error, stackTrace) {
                    const snackBar = SnackBar(
                        content: Text('INVALID CREDENTIALS. Try again.'),
                        duration: Duration(milliseconds: 5000),
                        backgroundColor: Color.fromARGB(255, 89, 193, 189));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
