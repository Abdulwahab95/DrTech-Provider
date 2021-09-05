import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon();

  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Icon(
          FlutterIcons.bell_outline_mco,
          color: Colors.white,
          size: 26,
        ));
  }
}
