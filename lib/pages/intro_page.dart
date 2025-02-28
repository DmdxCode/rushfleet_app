import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/footer.dart';
import 'package:spatch_flutter/components/my_buttons.dart';
import 'package:spatch_flutter/pages/login_page.dart';
import 'package:spatch_flutter/pages/register_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    Text(
                      "spatch",
                      style: TextStyle(
                          color: Color(0xFF7000F6),
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                          fontFamily: 'MazzardH-SemiBoldItalic.ttf'),
                    ),
                    Image.asset(
                      "lib/images/Vector.png",
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
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
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Let Spatch take care of that",
                            style: TextStyle(color: Colors.grey[600]),
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
                        text: "Register with Spatch",
                        color: Color(0xFF7000F6),
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
                        text: "Login to Spatch",
                        color: Colors.white,
                        fontcolor: Colors.grey.shade600,
                        border: Border.all(
                          color: Colors.grey.shade600,
                        ),
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
