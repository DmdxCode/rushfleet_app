import 'package:flutter/material.dart';

class BookingButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final void Function()? onTap;
  final Border border;
  final Color color;
  const BookingButton({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onTap,
    required this.border,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 113,
        height: 35,
        decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(7),
            color: Color(0XFFd9e8E1)),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                color: color,
                imagePath,
                height: 20,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
