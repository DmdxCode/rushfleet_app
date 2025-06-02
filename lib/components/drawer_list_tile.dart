import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String icon;
  final String text;
  final void Function()? onTap;

  const DrawerListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        color: Colors.black,
        icon,
        height: 20,
        width: 35,
      ),
      title: Text(
        text,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
