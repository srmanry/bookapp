import 'package:flutter/material.dart';
import 'package:libararybd/core/util/custom_color.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: appColor,
  brightness: Brightness.light,
  hintColor: mutedTextColor,
  scaffoldBackgroundColor: bodyColor,
  cardColor: surfaceColor,
  colorScheme: const ColorScheme.light(
    primary: appColor,
    secondary: accentColor,
    error: dangerColor,
    surface: surfaceColor,
    onSurface: titleColor,
    outline: borderColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    foregroundColor: titleColor,
    titleTextStyle: TextStyle(
      color: titleColor,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      color: titleColor,
      letterSpacing: -0.8,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: titleColor,
      letterSpacing: -0.5,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: titleColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: titleColor,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: mutedTextColor,
      height: 1.45,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surfaceColor,
    hintStyle: const TextStyle(
      color: mutedTextColor,
      fontSize: 14,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: appColor, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: dangerColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: dangerColor, width: 1.4),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appColor,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    color: surfaceColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
      side: const BorderSide(color: borderColor),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: titleColor,
    contentTextStyle: const TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: surfaceColor,
    indicatorColor: appColor.withValues(alpha: 0.14),
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) => TextStyle(
        color:
            states.contains(WidgetState.selected) ? appColor : navInactiveColor,
        fontSize: 12,
        fontWeight: states.contains(WidgetState.selected)
            ? FontWeight.w700
            : FontWeight.w500,
      ),
    ),
    iconTheme: WidgetStateProperty.resolveWith(
      (states) => IconThemeData(
        color:
            states.contains(WidgetState.selected) ? appColor : navInactiveColor,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: appColor,
    ),
  ),
);
