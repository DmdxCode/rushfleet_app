import 'package:flutter/material.dart';
import 'package:spatch_flutter/components/contact_for_support_card.dart';
import 'package:spatch_flutter/components/mobile_site.dart';
import 'package:spatch_flutter/components/spatch_logo.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF061F16)),
      child: Column(
        children: [
          ContactCard(),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SpatchLogo(),
                Text(
                  "We delivered over 20,000 jobs successfully since we started this journey.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0XFFD4E9E2),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Mobilesite(),
        ],
      ),
    );
  }
}
