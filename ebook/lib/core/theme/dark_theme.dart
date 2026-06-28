import 'package:flutter/material.dart';
import 'package:libararybd/core/util/custom_color.dart';

ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: appColor,
    brightness: Brightness.dark,
    hintColor: const Color(0xFF9FB0A9),
    scaffoldBackgroundColor: const Color(0xFF0E1715),
    cardColor: const Color(0xFF16211E),
    colorScheme: const ColorScheme.dark(
        primary: Color(0xFF74D2BB),
        secondary: accentColor,
        error: dangerColor,
        surface: Color(0xFF16211E),
        onSurface: Color(0xFFF2F6F4),
        outline: Color(0xFF2B3B36)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF16211E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF2B3B36)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF74D2BB), width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF16211E),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: appColor)),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFFF2F6F4),
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFB3C1BC),
      ),
    ));
