import 'package:flutter/material.dart';

class MySocials extends StatelessWidget {
  final String iconPath;
  const MySocials({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Image.asset(
        iconPath,
      ),
    );
  }
}
