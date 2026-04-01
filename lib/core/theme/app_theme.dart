import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _primary = Color(0xFF6200EE);
  static const Color _secondary = Color(0xFF03DAC6);
  static const Color _error = Color(0xFFB00020);

  static ThemeData getLightTheme([ColorScheme? dynamicColor]) {
    final colorScheme = dynamicColor ?? ColorScheme.fromSeed(
      seedColor: _primary,
      secondary: _secondary,
      error: _error,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  static ThemeData getDarkTheme([ColorScheme? dynamicColor]) {
    final colorScheme = dynamicColor ?? ColorScheme.fromSeed(
      seedColor: _primary,
      secondary: _secondary,
      error: _error,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
