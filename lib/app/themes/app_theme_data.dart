import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF015738),
      secondary: Color(0xFFffd525),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF015738),
      secondary: Color(0xFFffd525),
    ),
  );
}
