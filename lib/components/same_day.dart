import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/booking_button.dart';
import 'package:spatch_flutter/components/booking_container_textfield.dart';
import 'package:spatch_flutter/components/booking_textfield.dart';

class SameDay extends StatefulWidget {
  const SameDay({super.key});

  @override
  State<SameDay> createState() => _SameDayState();
}

class _SameDayState extends State<SameDay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 25, // Softness of the shadow
            spreadRadius: 1, // How far the shadow spreads
            offset: Offset(3, 3), // X and Y offset
          ),
        ],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Same Day",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Image.asset(
                    "lib/images/down.png",
                    height: 8,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BookingButton(
                  imagePath: "lib/images/sender.png",
                  text: "I'm the sender",
                ),
                BookingButton(
                  imagePath: "lib/images/receiver.png",
                  text: "I'm the receiver",
                ),
                BookingButton(
                  imagePath: "lib/images/guest.png",
                  text: "Book for guest",
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            BookingContainerTextfield()
          ],
        ),
      ),
    );
  }
}
