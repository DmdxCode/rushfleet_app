import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spatch_flutter/components/booking_textfield.dart';

class RowTextfield extends StatelessWidget {
  final String text;
  final String imagePath;
  final String iconPath;
  const RowTextfield({
    super.key,
    required this.text,
    required this.imagePath,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 20,
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          width: 280,
          child: BookingTextfield(
            hintText: text,
          ),
        ),
        Image.asset(
          iconPath,
          height: 10,
        )
      ],
    );
  }
}
