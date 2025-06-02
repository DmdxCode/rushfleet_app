// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/login_textfield.dart';
import 'package:spatch_flutter/components/my_buttons.dart';
import 'package:spatch_flutter/components/password_textfield.dart';
import 'package:spatch_flutter/components/sign_in_alert_dialog.dart';
import 'package:spatch_flutter/components/spatch_logo.dart';
import 'package:spatch_flutter/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailregcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  Future<void> signUpAndSendVerification() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF12AA6C),
            ),
          );
        });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailregcontroller.text,
        password: _passwordcontroller.text,
      );
      User? users = userCredential.user;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e);
    }
  }

  void showErrorMessage(FirebaseException e) {
    String message = (e.code);
    if (e.code == 'invalid-email') {
      message = "The email address is not valid.";
    } else if (e.code == 'user-disabled') {
      message = "This user account has been disabled.";
    } else if (e.code == 'user-not-found') {
      message = "No user found for this email.";
    } else if (e.code == 'wrong-password') {
      message = "Incorrect password. Please try again.";
    } else if (e.code == 'too-many-requests') {
      message = "Too many attempts. Try again later.";
    } else if (e.code == 'network-request-failed') {
      message = "No internet connection. Please check your network";
    } else if (e.code == 'channel-error') {
      message = "Please enter your credentials";
    } else if (e.code == 'invalid-credential') {
      message = "Wrong password or email";
    }
    showDialog(
      context: context,
      builder: (context) {
        return SignInAlertDialog(
          message: message,
          confirmText: 'Ok',
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // Future<void> checkEmailVerified() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   await user?.reload(); // Refresh user data

  //   if (user != null && user.emailVerified) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Email verified! Redirecting...")),
  //     );
  //     // Navigate to Home Page (Replace with your actual home page)
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginPage()),
  //     );
  //   } else {
  //     showDialog(
  //     context: context,
  //     builder: (context) {
  //       return SignInAlertDialog(
  //         message: '',
  //         confirmText: 'Ok',
  //         onConfirm: () {
  //           Navigator.pop(context);
  //         },
  //       );
  //     },
  //   );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text("Email not verified yet! Please check your inbox.")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF061F16),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400, // Set the maximum width
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SpatchLogo(),
                      const SizedBox(
                        height: 60,
                      ),
                      Column(
                        children: [
                          Text(
                            "Sign in to RushFleet",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 25),
                          ),
                          Text(
                            "Please enter your sign in detail",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          LoginTextfield(
                            controller: _emailregcontroller,
                            icon: Icons.mail_rounded,
                            hintText: "Email",
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          PasswordTextfield(
                            controller: _passwordcontroller,
                            icon: Icons.lock,
                            hintText: "Password",
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          MyButtons(
                              text: "Continue",
                              color: Color(0xFF12AA6C),
                              fontcolor: Colors.white,
                              border: Border(),
                              onTap: signUpAndSendVerification),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "By continuing, you agree to our Privacy Policy and our Terms of Service",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
