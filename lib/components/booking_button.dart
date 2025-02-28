import 'package:flutter/material.dart';

class BookingButton extends StatelessWidget {
  final String imagePath;
  final String text;
  const BookingButton({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 113,
      height: 35,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7), color: Colors.grey[100]),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
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
    );
  }
}
