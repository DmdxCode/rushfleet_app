import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/login_textfield.dart';
import 'package:spatch_flutter/components/my_buttons.dart';
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
            child: CircularProgressIndicator(),
          );
        });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailregcontroller.text,
        password: _passwordcontroller.text,
      );
      User? user = userCredential.user;
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
      message = "No internet connection. Please check your network.";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        message,
        selectionColor: Colors.red,
      )),
    );
  }

  Future<void> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Refresh user data

    if (user != null && user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email verified! Redirecting...")),
      );
      // Navigate to Home Page (Replace with your actual home page)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Email not verified yet! Please check your inbox.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SpatchLogo(),
                  const SizedBox(
                    height: 100,
                  ),
                  Column(
                    children: [
                      Text(
                        "Sign in to Spatch.",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please enter your sign in detail",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      LoginTextfield(
                        controller: _emailregcontroller,
                        icon: Icons.mail_rounded,
                        hintText: "Email",
                        obscureText: false,
                        keyboardType: TextInputType.none,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LoginTextfield(
                        controller: _passwordcontroller,
                        icon: Icons.lock,
                        hintText: "Password",
                        obscureText: true,
                        keyboardType: TextInputType.none,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      MyButtons(
                          text: "Continue",
                          color: Color(0xFF7000F6),
                          fontcolor: Colors.white,
                          border: Border(),
                          onTap: signUpAndSendVerification),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "By continuing, you agree to our Privacy Policy and our Terms of Service",
                        softWrap: true,
                        overflow: TextOverflow.visible,
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
