import 'package:flutter/material.dart';

class RecieptLogo extends StatelessWidget {
  const RecieptLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "RushFleet",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
              fontFamily: 'MazzardH-SemiBoldItalic.ttf'),
        ),
        Image.asset(
          "lib/images/result.png",
          height: 40,
          width: 40,
          color: Color(0xFF12AA6C),
        ),
      ],
    );
  }
}
