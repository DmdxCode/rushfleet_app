import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/booking_button.dart';
import 'package:spatch_flutter/components/booking_container_textfield.dart';
import 'package:spatch_flutter/components/guest_booking.dart';
import 'package:spatch_flutter/components/receiver_booking_container.dart';

class International extends StatefulWidget {
  const International({super.key});

  @override
  State<International> createState() => _InternationalState();
}

class _InternationalState extends State<International> {
  String _selectedContainer = "sender"; // No container shown initially
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "International",
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
                  color: Color(0xFF12AA6C),
                  imagePath: "lib/images/userrf.png",
                  text: "I'm the sender",
                  border: _selectedContainer == "sender"
                      ? Border.all(color: Color(0xFF12AA6C), width: 0.4)
                      : Border(),
                  onTap: () {
                    setState(() {
                      _selectedContainer = "sender"; // Show sender container
                    });
                  },
                ),
                BookingButton(
                  color: Color(0xffFF9E00),
                  imagePath: "lib/images/userrf.png",
                  text: "I'm the receiver",
                  border: _selectedContainer == "receiver"
                      ? Border.all(color: Color(0xFF12AA6C), width: 0.4)
                      : Border(),
                  onTap: () {
                    setState(() {
                      _selectedContainer =
                          "receiver"; // Show receiver container
                    });
                  },
                ),
                BookingButton(
                  color: Color(0xFF12AA6C),
                  imagePath: "lib/images//userrf.png",
                  text: "Book for guest",
                  border: _selectedContainer == "guest"
                      ? Border.all(color: Color(0xFF12AA6C), width: 0.4)
                      : Border(),
                  onTap: () {
                    setState(() {
                      _selectedContainer = "guest"; // Show receiver container
                    });
                  },
                )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              if (_selectedContainer == "sender")
                BookingContainerTextfield()
              else if (_selectedContainer == "receiver")
                ReceiverBookingContainer(
           
                )
              else if (_selectedContainer == "guest")
                GuestBooking(
                  
                )
            ],
          ),
        ),
      ),
    );
  }
}
