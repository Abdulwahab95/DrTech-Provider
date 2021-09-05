import 'package:flutter/material.dart';

class NavBarIcon extends StatefulWidget {
  final icon, onTap, isActive;
  const NavBarIcon(this.icon, this.onTap, this.isActive);

  @override
  _NavBarIconState createState() => _NavBarIconState();
}

class _NavBarIconState extends State<NavBarIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }
}
