import 'package:flutter/material.dart';

class BookingTextfield extends StatelessWidget {
  final String hintText;
  const BookingTextfield({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorHeight: 10,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0)),
    );
  }
}
