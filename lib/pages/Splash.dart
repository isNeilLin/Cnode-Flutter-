import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Image.asset('assets/splash.jpeg',fit: BoxFit.contain,),
    );
  }
}