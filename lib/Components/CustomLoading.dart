import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final width;
  CustomLoading({this.width = 30.0});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill, image: AssetImage("assets/images/loader.gif"))),
    );
  }
}
