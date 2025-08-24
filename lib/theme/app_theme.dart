import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      appBarTheme: _lightAppBarTheme,
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: _inputDecorationTheme(Colors.black),
      elevatedButtonTheme: _elevatedButtonTheme(Colors.white, Colors.black),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      appBarTheme: _darkAppBarTheme,
      scaffoldBackgroundColor: Colors.black,
      inputDecorationTheme: _inputDecorationTheme(Colors.white),
      elevatedButtonTheme: _elevatedButtonTheme(Colors.black, Colors.white),
    );
  }

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.black,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.black,
    surface: Colors.black,
    onSurface: Colors.white,
  );

  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
  );

  static InputDecorationTheme _inputDecorationTheme(Color borderColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
