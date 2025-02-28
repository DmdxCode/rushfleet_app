import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String icon;
  final String text;
  void Function()? onTap;

  DrawerListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: Image.asset(
          icon,
          height: 25,
        ),
        title: Text(
          text,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade700),
        ),
        onTap: onTap,
      ),
    );
  }
}
