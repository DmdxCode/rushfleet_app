import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "lib/images/background_photo.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              "Manage your deliveries with rushfleet easily.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Time is the most precious thing you have when runnung your business. You can off the time to ponder on logistics.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xFF12AA6C),
              ),
              child: Center(
                child: Text(
                  "Contact for Support",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
