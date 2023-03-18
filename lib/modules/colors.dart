import 'package:flutter/material.dart';

const Color primeColor = Color.fromRGBO(255, 102, 0, 1);
const Color secondaryColor = Color.fromRGBO(255, 251, 0, 1);
const Color focusColor = Color.fromRGBO(255, 189, 0, 1);
const primeGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [primeColor, secondaryColor],
);
MaterialColor primeMaterialColor = MaterialColor(primeColor.value, <int, Color>{
  50: primeColor.withOpacity(0.1),
  100: primeColor.withOpacity(0.2),
  200: primeColor.withOpacity(0.3),
  300: primeColor.withOpacity(0.4),
  400: primeColor.withOpacity(0.5),
  500: primeColor.withOpacity(0.6),
  600: primeColor.withOpacity(0.7),
  700: primeColor.withOpacity(0.8),
  800: primeColor.withOpacity(0.9),
  900: primeColor.withOpacity(1),
});
final themeColors = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
  primary: primeColor,
));
