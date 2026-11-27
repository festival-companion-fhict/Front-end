import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'taal.dart';

/// Het weer op het festivalterrein (Biddinghuizen).
/// Komt van Open-Meteo: gratis, geen sleutel nodig. Elke 15 minuten opnieuw.
class Weer {
  const Weer(this.graden, this.code, this.regenKans);

  final double graden; // temperatuur in °C
  final int code; // weercode (0 = zonnig, 3 = bewolkt, 61 = regen ...)
  final List<int> regenKans; // kans op regen per uur, vanaf nu (in %)

  /// Het laatste weer. null = nog aan het laden.
  static final ValueNotifier<Weer?> huidig = ValueNotifier(null);

  static Timer? _timer;

  /// Start met ophalen (één keer, bij het opstarten van de app).
  static void start() {
    if (_timer != null) return;
    _haalOp();
    _timer = Timer.periodic(const Duration(minutes: 15), (_) => _haalOp());
  }

  static Future<void> _haalOp() async {
    try {
      final antwoord = await http
          .get(
            Uri.parse(
              'https://api.open-meteo.com/v1/forecast'
              '?latitude=52.43&longitude=5.77'
              '&current=temperature_2m,weather_code'
              '&hourly=precipitation_probability&forecast_hours=12'
              '&timezone=Europe%2FAmsterdam',
            ),
          )
          .timeout(const Duration(seconds: 15));
      if (antwoord.statusCode != 200) return;
      final data = jsonDecode(antwoord.body) as Map<String, dynamic>;
      final nu = data['current'] as Map<String, dynamic>;
      final kansen = (data['hourly']['precipitation_probability'] as List)
          .map((k) => (k as num?)?.toInt() ?? 0)
          .toList();
      huidig.value = Weer(
        (nu['temperature_2m'] as num).toDouble(),
        (nu['weather_code'] as num).toInt(),
        kansen,
      );
    } catch (_) {
      // Geen internet? Dan houden we het vorige weer en proberen het straks weer.
    }
  }

  /// Bijv. '18°C'.
  String get temperatuur => '${graden.round()}°C';

  /// Naam van het pictogram in assets/pictograms (zonder .png).
  String get pictogram => switch (code) {
    0 => 'Zonnig',
    1 || 2 => 'Half_bewolkt',
    3 => 'Bewolkt',
    45 || 48 => 'Mist',
    >= 95 => 'Onweer',
    (>= 71 && <= 77) || 85 || 86 => 'Sneeuw',
    >= 51 => 'Regen',
    _ => 'Bewolkt',
  };

  /// Reserve-icoon als het eigen pictogram (nog) niet bestaat.
  IconData get reserveIcoon => switch (pictogram) {
    'Zonnig' => LucideIcons.sun,
    'Half_bewolkt' => LucideIcons.cloudSun,
    'Mist' => LucideIcons.cloudFog,
    'Onweer' => LucideIcons.cloudLightning,
    'Sneeuw' => LucideIcons.snowflake,
    'Regen' => LucideIcons.cloudRain,
    _ => LucideIcons.cloud,
  };

  /// Bijv. 'Droog tot 23:00' of 'Kans op regen'.
  String get verwachting {
    final regenUur = regenKans.indexWhere((kans) => kans >= 50);
    if (regenUur == 0) return t('Kans op regen');
    if (regenUur == -1) return t('Droog de komende uren');
    final uur = (DateTime.now().hour + regenUur) % 24;
    return '${t('Droog tot')} ${uur.toString().padLeft(2, '0')}:00';
  }
}
