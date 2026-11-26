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
  static const muted = Color(0xFFA0A0A0); // lichter grijs = beter leesbaar
  static const redText = Color(0xFFFF6B77); // lichter rood voor kleine tekst
}

/// Koppen. Groot (22 of meer) = Oswald Bold, kleiner = Bebas Neue.
TextStyle bc(
  double size, {
  Color? color,
  double? height,
  double spacing = 0,
  bool italic = false,
  FontWeight weight = FontWeight.w900,
  List<Shadow>? shadows,
}) {
  final groot = size >= 22;
  return TextStyle(
    fontFamily: groot ? 'Oswald' : 'Bebas',
    fontSize: groot ? size : size + 2,
    fontWeight: FontWeight.normal, // de dikte zit al in het lettertype zelf
    fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    // Regels mogen niet over elkaar heen vallen.
    height: height != null && height < 1.05 ? 1.05 : height,
    letterSpacing: groot ? spacing.clamp(-0.5, 2.0) : 0.5,
    color: color,
    shadows: shadows,
  );
}

/// Kleine tekst.
/// Dik (labels, knoppen) = Bebas Neue, minimaal 14.
/// Dun (uitleg, zinnen) = Inter, minimaal 12.
TextStyle inter(
  double size, {
  Color? color,
  FontWeight weight = FontWeight.w900,
  double spacing = 0,
  double? height,
}) {
  final label = weight.index >= FontWeight.w700.index;
  // Klein rood is slecht leesbaar op zwart: maak het lichter.
  final kleur = color == DQ.red && size < 14 ? DQ.redText : color;
  if (label) {
    return TextStyle(
      fontFamily: 'Bebas',
      fontSize: size + 5 < 14 ? 14 : size + 5,
      fontWeight: FontWeight.normal,
      letterSpacing: spacing < 0.6 ? 0.6 : (spacing > 1.5 ? 1.5 : spacing),
      height: height,
      color: kleur,
    );
  }
  return TextStyle(
    fontFamily: 'Inter',
    fontSize: size + 3 < 12 ? 12 : size + 3,
    fontWeight: weight,
    letterSpacing: spacing > 1 ? 1 : spacing,
    height: height,
    color: kleur,
  );
}

ThemeData buildTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: DQ.ink,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(
      primary: DQ.lime,
      secondary: DQ.red,
      surface: DQ.ink,
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: DQ.lime),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: DQ.text, displayColor: DQ.text),
  );
}
