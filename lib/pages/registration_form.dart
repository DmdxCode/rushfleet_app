import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/login_textfield.dart';
import 'package:spatch_flutter/components/my_buttons.dart';
import 'package:spatch_flutter/components/spatch_logo.dart';
import 'package:spatch_flutter/pages/success_verification_page.dart';

class RegistrationForm extends StatefulWidget {
  final User user;
  const RegistrationForm({super.key, required this.user});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? verificationId;

  Future<void> registerUser() async {
    String name = _usernameController.text.trim();
    String phone = _phoneController.text.trim();

    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all details")),
      );
      return;
    }

    try {
      await _firestore.collection("user").doc(widget.user.uid).set({
        "uid": widget.user.uid,
        "name": name,
        "phone": phone,
        "email": widget.user.email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await widget.user.updateDisplayName(name);
      await widget.user.reload();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessVerificationPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
    }
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Center(child: Text(message)));
        });
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400, // Set the maximum width
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      SpatchLogo(),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        "Register with Spatch.",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 25),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: "Continue creating account with ",
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[700]),
                          children: [
                            TextSpan(
                              text: user?.email ?? "No email available",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      LoginTextfield(
                        controller: _usernameController,
                        icon: Icons.person,
                        hintText: "Full Name",
                        obscureText: false,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      LoginTextfield(
                        controller: _phoneController,
                        icon: Icons.phone,
                        hintText: "Phone Number",
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 40),
                      MyButtons(
                        text: "Continue",
                        color: const Color(0xFF7000F6),
                        fontcolor: Colors.white,
                        border: Border(),
                        onTap: registerUser,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "By continuing, you agree to our Privacy Policy and our Terms of Service",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
