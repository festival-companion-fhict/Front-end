import 'dart:async';

import 'package:flutter/foundation.dart';

import 'festival_data.dart';
import 'instellingen.dart';

/// DEMO-TIJD
/// true  = de app doet alsof het vandaag [demoDag] is (met de klok van nu).
///         Handig om te testen en te laten zien, want het festival is in juni.
/// false = de app gebruikt de echte datum. Zet dit op false vóór het festival.
const bool demoTijd = true;
const String demoDag = 'SAT 28';

/// Waar staat een optreden ten opzichte van nu?
enum ActStatus { geweest, live, straks }

/// Alles over "hoe laat is het op het festival".
class FestivalTijd {
  /// Tikt elke 30 seconden (en zodra de line-up binnen is).
  /// Schermen luisteren hiernaar, zodat ze vanzelf bijwerken.
  static final ValueNotifier<int> tik = _maakTik();

  static ValueNotifier<int> _maakTik() {
    final teller = ValueNotifier<int>(0);
    Timer.periodic(const Duration(seconds: 30), (_) => teller.value++);
    laadLineup().then((_) => teller.value++);
    return teller;
  }

  /// De festivaldag van vandaag, bijv. 'SAT 28'.
  /// '' = vandaag is geen festivaldag.
  static String get vandaag {
    if (demoTijd) return demoDag;
    final nu = DateTime.now();
    if (nu.month != 6) return '';
    const weekdagen = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final dag = '${weekdagen[nu.weekday - 1]} ${nu.day}';
    return festivalDagen.contains(dag) ? dag : '';
  }

  /// Hoeveel minuten na middernacht het nu is (14:30 = 870).
  static int get nu {
    final tijd = DateTime.now();
    return tijd.hour * 60 + tijd.minute;
  }

  /// '18:45' -> 1125 minuten.
  static int _minuten(String tijd) =>
      int.parse(tijd.substring(0, 2)) * 60 + int.parse(tijd.substring(3, 5));

  static int begin(Act act) => _minuten(act.time);

  /// Eindtijd in minuten. Gaat een act over middernacht (23:30-01:00),
  /// dan tellen we er een dag (1440 minuten) bij op.
  static int eind(Act act) {
    final e = _minuten(act.end);
    return e <= begin(act) ? e + 1440 : e;
  }

  static ActStatus status(Act act) {
    final dagen = festivalDagen;
    final vandaagNr = dagen.indexOf(vandaag);
    final actNr = dagen.indexOf(act.dag);
    if (vandaagNr == -1 || actNr > vandaagNr) return ActStatus.straks;
    if (actNr < vandaagNr) return ActStatus.geweest;
    if (eind(act) <= nu) return ActStatus.geweest;
    if (begin(act) <= nu) return ActStatus.live;
    return ActStatus.straks;
  }

  static bool isLive(Act act) => status(act) == ActStatus.live;

  /// Nog hoeveel minuten tot het einde (voor een live act).
  static int minutenNog(Act act) => eind(act) - nu;

  /// Over hoeveel minuten begint deze act?
  static int minutenTot(Act act) => begin(act) - nu;

  /// Hoe ver de act is: 0.0 = net begonnen, 1.0 = klaar.
  static double voortgang(Act act) =>
      ((nu - begin(act)) / (eind(act) - begin(act))).clamp(0.0, 1.0);

  /// Wie speelt er nu? Jouw bewaarde acts (♡) eerst.
  static Act? nuLive() => _eerste(
    lineup.where((a) => a.dag == vandaag && isLive(a)),
  );

  /// Wie komt hierna? Jouw bewaarde acts (♡) eerst, anders de eerstvolgende.
  static Act? hierna() => _eerste(
    lineup.where((a) => a.dag == vandaag && status(a) == ActStatus.straks),
  );

  static Act? _eerste(Iterable<Act> acts) {
    if (acts.isEmpty) return null;
    final lijst = acts.toList()
      ..sort((a, b) => begin(a).compareTo(begin(b)));
    for (final act in lijst) {
      if (Instellingen.bewaard.contains(act.sleutel)) return act;
    }
    return lijst.first;
  }
}