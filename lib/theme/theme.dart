import 'package:vehicle_counter/imports_library.dart';
class AppTheme {
  // Light Theme
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

  // Dark Theme
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

  // Light Color Scheme
  static const ColorScheme _lightColorScheme = ColorScheme(
    primary: Colors.black,
    secondary: Colors.black,
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  // Dark Color Scheme
  static const ColorScheme _darkColorScheme = ColorScheme(
    primary: Colors.white,
    secondary: Colors.white,
    surface: Colors.black,
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  );

  // Light AppBar Theme
  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black), // Black icons for AppBar
  );

  // Dark AppBar Theme
  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white), // White icons for AppBar
  );

  // Input Decoration Theme
  static InputDecorationTheme _inputDecorationTheme(Color borderColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  // Elevated Button Theme
  static ElevatedButtonThemeData _elevatedButtonTheme(
      Color backgroundColor,
      Color foregroundColor,
      ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
