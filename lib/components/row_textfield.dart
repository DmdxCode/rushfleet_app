import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/booking_textfield.dart';

class RowTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String imagePath;
  final String iconPath;
  final Color iconColor;
  final FormFieldValidator<String> validator; // Add validator parameter

  const RowTextfield({
    super.key,
    required this.text,
    required this.imagePath,
    required this.iconPath,
    required this.controller,
    required this.iconColor,
    required this.validator, // Add validator to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                imagePath,
                color: iconColor,  // Apply color to the image icon
                height: 20,
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 280,
                child: BookingTextfield(
                  controller: controller,
                  validator: validator, // Pass validator here
                  hintText: text,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => controller.clear(),
            child: Image.asset(
              iconPath,
              height: 10,
            ),
          ),
        ],
      ),
    );
  }
}
