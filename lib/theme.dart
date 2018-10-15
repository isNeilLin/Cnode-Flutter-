import 'package:flutter/material.dart';

final ThemeData lightTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Color.fromRGBO(51, 51, 51, 1.0),
  primaryColorBrightness: Brightness.dark,
  accentColor: Color.fromRGBO(139, 196, 0, 1.0),
  accentColorBrightness: Brightness.light,
);

final ThemeData darkTheme = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color.fromRGBO(58, 58, 58, 1.0),
  primaryColorBrightness: Brightness.dark,
  accentColor: Color.fromRGBO(139, 196, 0, 1.0),
  accentColorBrightness: Brightness.dark
);

