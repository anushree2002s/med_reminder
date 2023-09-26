import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder_app/pages/front_page/resusables/reusable_widgets.dart';
import 'package:medicine_reminder_app/pages/front_page/sign_in_page.dart';
import 'package:medicine_reminder_app/pages/home_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    const snackBar = SnackBar(
                      content: Text('You are now registered. Sign in NOW.'),
                      duration: Duration(milliseconds: 5000),
                      backgroundColor: Color.fromARGB(255, 89, 193, 189),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  }).onError((error, stackTrace) {
                    const snackBar = SnackBar(
                        content:
                            Text('Please enter all the details CAREFULLY.'),
                        duration: Duration(milliseconds: 5000),
                        backgroundColor: Color.fromARGB(255, 89, 193, 189));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                })
              ],
            ),
          ))),
    );
  }
}
