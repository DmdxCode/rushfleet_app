import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/app_button.dart';
import 'package:spatch_flutter/components/socials.dart';

class Mobilesite extends StatelessWidget {
  const Mobilesite({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company",
                        style: TextStyle(
                            color: Color(0XFFD4E9E2),
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Company",
                        style: TextStyle(
                          color: Color(0XFFD4E9E2),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Blog",
                        style: TextStyle(
                          color: Color(0XFFD4E9E2),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Career",
                        style: TextStyle(
                          color: Color(0XFFD4E9E2),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "About",
                        style: TextStyle(
                          color: Color(0XFFD4E9E2),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Service",
                        style: TextStyle(
                            color: Color(0XFFD4E9E2),
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Same Day",
                        style: TextStyle(
                          color: Color(0XFFD4E9E2),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "International",
                        style: TextStyle(
                          color: Color(0XFFD4E9E2),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Express",
                        style: TextStyle(
                          color: Color(0XFFD4E9E2),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Buck Service",
                        style: TextStyle(
                          color: Color(0XFFD4E9E2),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Download our app",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  AppButton(
                    iconcolor: Colors.white,
                    onTap: () {},
                    imagePath: "lib/images/ apple.png",
                    minitext: "Available on",
                    minitextcolor: Colors.white,
                    text: "App Store",
                    color: Color(0xFF12AA6C),
                    fontcolor: Colors.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AppButton(
                    iconcolor: Color(0xFF12AA6C),
                    onTap: () {},
                    imagePath: "lib/images/ google.png",
                    minitext: "Get in on",
                    minitextcolor: Colors.black,
                    text: "Google Play",
                    color: Color(0XFFD4E9E2),
                    fontcolor: Colors.black,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Connect with us on social",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0XFFD4E9E2),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          MySocials(iconPath: "lib/images/instagram2.png"),
                          MySocials(iconPath: "lib/images/twitter.png"),
                          MySocials(iconPath: "lib/images/linkedin2.png"),
                          MySocials(iconPath: "lib/images/facebook2.png"),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "© Spatch 2021, All Rights Reserved",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
