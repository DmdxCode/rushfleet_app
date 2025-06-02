import 'package:flutter/material.dart';

class RequestButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color fontcolor;
  final Border border;
  final IconData icon;

  const RequestButton({
    super.key,
    required this.text,
    required this.color,
    required this.fontcolor,
    required this.border,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
            border: border),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: fontcolor,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                icon,
                color: Colors.white,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
