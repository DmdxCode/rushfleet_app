import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/home_tiles.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width > 600
              ? (MediaQuery.of(context).size.width - 600) /
                  10 // Centered margin
              : 100,
          horizontal: MediaQuery.of(context).size.width > 600
              ? (MediaQuery.of(context).size.width - 600) / 2 // Centered margin
              : 16), // Default small margin on smaller screens
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "How would you like to request?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            HomeTiles(),
          ],
        ),
      ),
    );
  }
}
