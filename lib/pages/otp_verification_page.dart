// ignore_for_file: library_private_types_in_public_api, use_super_parameters, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spatch_flutter/pages/home_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String name;

  const OtpVerificationPage({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
    required this.name,
  }) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyOtp() async {
    String otp = _otpController.text.trim();

    if (otp.isEmpty) {
      showErrorMessage("Please enter OTP");
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // ✅ Save user name after verification
      await userCredential.user?.updateDisplayName(widget.name);
      await userCredential.user?.reload();

      print("User registered with name: ${userCredential.user?.displayName}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      showErrorMessage("Invalid OTP. Try again.");
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.red))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter the OTP sent to ${widget.phoneNumber}",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "OTP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyOtp,
              child: Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
