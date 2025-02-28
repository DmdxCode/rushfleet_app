import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/dashboard.dart';
import 'package:spatch_flutter/components/my_drawer.dart';
import 'package:spatch_flutter/pages/intro_page.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Change to your desired color
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light backgrounds
    ));
  }

  final user = FirebaseAuth.instance.currentUser;

  void signOut(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => IntroPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black, // Change status bar to black
        statusBarIconBrightness: Brightness.light, // White icons
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Color(0xFF7000F6),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black, // Change status bar color to black
            statusBarIconBrightness: Brightness.light, // White icons
          ),
        ),
        extendBodyBehindAppBar: true,
        drawer: MyDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                "lib/images/background_image.png",
                fit: BoxFit.cover,
              ),
            ),
            Center(child: Dashboard())
          ],
        ),
      ),
    );
  }
}
