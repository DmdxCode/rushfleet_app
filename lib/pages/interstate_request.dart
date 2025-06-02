import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spatch_flutter/components/request_type/interstate.dart';
import 'package:spatch_flutter/pages/home_page.dart';

class InterstateRequestPage extends StatelessWidget {
  const InterstateRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFF12AA6C),
        elevation: 0,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white, // Change status bar color to black
          statusBarIconBrightness: Brightness.light, // White icons
        ),
        title: Text(
          "Request",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            child: Icon(Icons.arrow_back_ios_new)),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              "lib/images/background_image.png",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width > 600
                    ? (MediaQuery.of(context).size.width - 600) /
                        10 // Centered margin
                    : 5,
                horizontal: MediaQuery.of(context).size.width > 600
                    ? (MediaQuery.of(context).size.width - 600) /
                        2 // Centered margin
                    : 20), // Default small margin on smaller screens
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 10,
                  ),
                  child: Row(
                    children: [],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Interstate(),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
