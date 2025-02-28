import 'package:flutter/material.dart';

class LoginTextfield extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  const LoginTextfield(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.obscureText,
      required this.keyboardType,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xFF7000F6),
        width: 2,
      ))),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            icon,
          ),
          hintText: hintText,
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }
}
