import 'package:flutter/material.dart';

class SpatchLogo extends StatelessWidget {
  const SpatchLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 0)),
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
    );
  }
}
