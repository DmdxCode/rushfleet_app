import 'package:flutter/material.dart';

class RecieptSocials extends StatelessWidget {
  final String iconPath;
  const RecieptSocials({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          // color: Colors.white, borderRadius: BorderRadius.circular(10)
          ),
      child: Image.asset(
        height: 15,
        color: Colors.white,
        iconPath,
      ),
    );
  }
}
