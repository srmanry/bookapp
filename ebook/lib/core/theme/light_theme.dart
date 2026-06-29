import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libararybd/core/util/custom_color.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: appColor,
  brightness: Brightness.light,
  hintColor: mutedTextColor,
  scaffoldBackgroundColor: bodyColor,
  cardColor: surfaceColor,
  fontFamily: GoogleFonts.sourceSans3().fontFamily,
  colorScheme: const ColorScheme.light(
    primary: appColor,
    secondary: accentColor,
    error: dangerColor,
    surface: surfaceColor,
    onSurface: titleColor,
    outline: borderColor,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    foregroundColor: titleColor,
    titleTextStyle: GoogleFonts.playfairDisplay(
      color: titleColor,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: titleColor,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: titleColor,
      letterSpacing: -0.3,
    ),
    titleLarge: GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: titleColor,
    ),
    bodyLarge: GoogleFonts.sourceSans3(
      fontSize: 16,
      color: titleColor,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.sourceSans3(
      fontSize: 14,
      color: mutedTextColor,
      height: 1.45,
    ),
    labelLarge: GoogleFonts.sourceSans3(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: titleColor,
      letterSpacing: 0.1,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surfaceColor,
    hintStyle: const TextStyle(color: mutedTextColor, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: appColor, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: dangerColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: dangerColor, width: 1.4),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: cardSoftColor,
    selectedColor: appColor.withValues(alpha: 0.12),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    labelStyle: const TextStyle(color: titleColor, fontWeight: FontWeight.w600),
    side: const BorderSide(color: borderColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appColor,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: appColor,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  ),
  cardTheme: CardThemeData(
    color: surfaceColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: const BorderSide(color: borderColor),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  dividerColor: borderColor,
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: appColor),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: titleColor,
    contentTextStyle: const TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: surfaceColor,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: surfaceColor,
    indicatorColor: appColor.withValues(alpha: 0.12),
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) => TextStyle(
        color: states.contains(WidgetState.selected) ? appColor : navInactiveColor,
        fontSize: 12,
        fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
      ),
    ),
    iconTheme: WidgetStateProperty.resolveWith(
      (states) => IconThemeData(
        color: states.contains(WidgetState.selected) ? appColor : navInactiveColor,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: appColor),
  ),
);
