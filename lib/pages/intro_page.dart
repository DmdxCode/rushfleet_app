import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/footer.dart';
import 'package:spatch_flutter/components/my_buttons.dart';
import 'package:spatch_flutter/components/spatch_logo.dart';
import 'package:spatch_flutter/pages/login_page.dart';
import 'package:spatch_flutter/pages/register_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF061F16),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    SizedBox(
                      height: 20,
                    ),
                    SpatchLogo(),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsetsDirectional.all(35),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Glad you made it here.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Need to deliver your merchandise?",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Let RushFleet take care of that",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MyButtons(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        text: "Register with RushFleet",
                        color: Color(0xFF12AA6C),
                        fontcolor: Colors.white,
                        border: Border(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyButtons(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        text: "Login to RushFleet",
                        color: Color(0xFF1D362B),
                        fontcolor: Colors.white,
                        border: Border(),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
