import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/my_buttons.dart';
import 'package:spatch_flutter/pages/home_page.dart';

class SuccessVerificationPage extends StatelessWidget {
  const SuccessVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF061F16),
      body: SizedBox(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                Text(
                  "Successful",
                  style: TextStyle(
                      color: Color(0xFF12AA6C),
                      fontWeight: FontWeight.w700,
                      fontSize: 21),
                ),
                Text(
                  "Welcome to RushFleet",
                  style: TextStyle(
                    color: Color(0xFF12AA6C),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
                MyButtons(
                  text: "Continue",
                  color: Color(0xFF12AA6C),
                  fontcolor: Colors.white,
                  border: Border(),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
