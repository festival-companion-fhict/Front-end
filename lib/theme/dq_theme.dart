import 'package:flutter/material.dart';

/// Alle kleuren uit het Figma-ontwerp op één plek.
/// Wil je een kleur aanpassen? Doe het hier, dan verandert hij overal.
class DQ {
  DQ._();

  // Basis
  static const ink = Color(0xFF0B0B0B); // achtergrond
  static const paper = Color(0xFFF3F0E9); // gebroken wit
  static const text = Color(0xFFF5F2ED); // standaard tekstkleur
  static const dark = Color(0xFF111111);

  // Merk-kleuren
  static const red = Color(0xFFFF2134);
  static const lime = Color(0xFFBDFC16);
  static const blue = Color(0xFF4A55FF);
  static const cyan = Color(0xFF00D9D9);
  static const yellow = Color(0xFFFFE500);

  // Extra kleuren van het home-scherm
  static const impact = Color(0xFF5A19FF);
  static const acid = Color(0xFFC8FF35);
  static const aqua = Color(0xFF90EADC);
  static const fuchsia = Color(0xFFF334B4);
  static const orange = Color(0xFFFF5638);

  // Grijstinten die vaak terugkomen
  static const line = Color(0xFF333333);
  static const line2 = Color(0xFF444444);
  static const muted = Color(0xFF777777);
}

/// Koppen: Barlow Condensed (dik en smal).
TextStyle bc(
  double size, {
  Color? color,
  double? height,
  double spacing = 0,
  bool italic = false,
  FontWeight weight = FontWeight.w900,
  List<Shadow>? shadows,
}) => TextStyle(
  fontFamily: 'BarlowCondensed',
  fontSize: size,
  fontWeight: weight,
  fontStyle: italic ? FontStyle.italic : FontStyle.normal,
  height: height,
  letterSpacing: spacing,
  color: color,
  shadows: shadows,
);

/// Kleine tekst: Inter.
TextStyle inter(double size, {Color? color, FontWeight weight = FontWeight.w900, double spacing = 0, double? height}) =>
    TextStyle(
      fontFamily: 'Inter',
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
      color: color,
    );

ThemeData buildTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: DQ.ink,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(primary: DQ.lime, secondary: DQ.red, surface: DQ.ink),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: DQ.lime),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: DQ.text, displayColor: DQ.text),
  );
}
