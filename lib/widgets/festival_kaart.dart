import 'package:flutter/material.dart';

import '../theme/dq_theme.dart';
import 'common.dart';

/// ─────────────────────────────────────────────────────────────
///  FESTIVALKAART
///  Jouw kaart-afbeelding met aanklikbare stages en icoontjes.
///  Alle plekken staan in pixels van de afbeelding (1337 × 1176).
/// ─────────────────────────────────────────────────────────────

/// Een stage op de kaart.
class KaartStage {
  const KaartStage(
    this.naam,
    this.kleur,
    this.vak, {
    required this.nu,
    required this.straks,
    required this.drukte,
    required this.lopen,
  });

  final String naam; // bijv. 'RED STAGE'
  final Color kleur; // kleur van de stage
  final Rect vak; // waar de stage op de afbeelding ligt (x, y, breedte, hoogte)
  final String nu; // wie er nu speelt
  final String straks; // wie er daarna speelt
  final String drukte; // bijv. 'ZEER DRUK'
  final String lopen; // bijv. '2 MIN'
}

/// Een punt op de kaart: eten, water, wc of EHBO.
class KaartPunt {
  const KaartPunt(this.soort, this.plek, this.titel, this.info, this.lopen);

  final String soort; // 'ETEN', 'WATER', 'WC' of 'EHBO'
  final Offset plek; // midden van het icoontje (x, y)
  final String titel;
  final String info;
  final String lopen;
}

// ── STAGES ── (pas hier de namen, artiesten en plekken aan)
const kaartStages = <KaartStage>[
  KaartStage(
    'BLUE STAGE',
    DQ.blue,
    Rect.fromLTWH(667, 360, 113, 46),
    nu: 'REBELION',
    straks: 'D-STURB · 19:00',
    drukte: 'DRUK',
    lopen: '6 MIN',
  ),
  KaartStage(
    'UV STAGE',
    Color(0xFFB57BFF),
    Rect.fromLTWH(788, 360, 78, 46),
    nu: 'KELTEK',
    straks: 'NEOPHYTE · 19:30',
    drukte: 'RUSTIG',
    lopen: '5 MIN',
  ),
  KaartStage(
    'PURPLE STAGE',
    Color(0xFF9B5CFF),
    Rect.fromLTWH(936, 413, 81, 44),
    nu: 'DJ THERA',
    straks: 'MUZZA · 20:00',
    drukte: 'RUSTIG',
    lopen: '3 MIN',
  ),
  KaartStage(
    'MAGENTA STAGE',
    Color(0xFFFF1FA8),
    Rect.fromLTWH(686, 452, 124, 46),
    nu: 'SOUND RUSH',
    straks: 'ATMOZFEARS · 19:30',
    drukte: 'DRUK',
    lopen: '5 MIN',
  ),
  KaartStage(
    'YELLOW STAGE',
    DQ.yellow,
    Rect.fromLTWH(845, 518, 63, 66),
    nu: 'ADARO',
    straks: 'B-FRONT · 19:00',
    drukte: 'GEMIDDELD',
    lopen: '2 MIN',
  ),
  KaartStage(
    'RED STAGE',
    DQ.red,
    Rect.fromLTWH(938, 466, 174, 148),
    nu: 'POWER HOUR',
    straks: 'SUB ZERO PROJECT · 19:10',
    drukte: 'ZEER DRUK',
    lopen: '1 MIN',
  ),
  KaartStage(
    'GOLD STAGE',
    Color(0xFFF7C97A),
    Rect.fromLTWH(728, 555, 63, 46),
    nu: 'THE DARKRAVER',
    straks: 'ANGERFIST · 20:00',
    drukte: 'DRUK',
    lopen: '4 MIN',
  ),
  KaartStage(
    'GREEN STAGE',
    Color(0xFF22E02B),
    Rect.fromLTWH(825, 605, 58, 71),
    nu: 'RAN-D',
    straks: 'ACTIVATOR · 19:30',
    drukte: 'GEMIDDELD',
    lopen: '2 MIN',
  ),
  KaartStage(
    'SILVER STAGE',
    Color(0xFFD6D6D6),
    Rect.fromLTWH(702, 650, 66, 40),
    nu: 'DEEP DIVE',
    straks: 'MYSTERY ACT · 21:00',
    drukte: 'RUSTIG',
    lopen: '4 MIN',
  ),
  KaartStage(
    'THEATRE',
    Colors.white,
    Rect.fromLTWH(710, 698, 57, 36),
    nu: 'COMEDY SHOW',
    straks: 'LIVE BAND · 20:00',
    drukte: 'RUSTIG',
    lopen: '5 MIN',
  ),
  KaartStage(
    'BLACK STAGE',
    Color(0xFF888888),
    Rect.fromLTWH(778, 707, 104, 70),
    nu: 'DR. PEACOCK',
    straks: 'SEFA · 20:00',
    drukte: 'DRUK',
    lopen: '3 MIN',
  ),
];

// ── ETEN, WATER, WC, EHBO ── (pas hier de plekken en teksten aan)
const kaartPunten = <KaartPunt>[
  KaartPunt(
    'ETEN',
    Offset(850, 466),
    'FOOD COURT NOORD',
    'Burgers, friet, vega bowls. Open tot 01:00.',
    '3 MIN',
  ),
  KaartPunt(
    'ETEN',
    Offset(760, 630),
    'FOOD COURT GOLD',
    'Pizza, noodles en snacks. Open tot 01:00.',
    '4 MIN',
  ),
  KaartPunt(
    'ETEN',
    Offset(855, 690),
    'FOOD TRUCKS',
    'Tacos, wraps en desserts. Open tot 00:00.',
    '3 MIN',
  ),
  KaartPunt(
    'DRINKEN',
    Offset(735, 425),
    'BAR BLUE',
    'Bier, frisdrank en mixdrankjes. Betalen met munten.',
    '6 MIN',
  ),
  KaartPunt(
    'DRINKEN',
    Offset(1160, 560),
    'BAR RED',
    'Bier, frisdrank en mixdrankjes. Betalen met munten.',
    '1 MIN',
  ),
  KaartPunt(
    'DRINKEN',
    Offset(690, 760),
    'BAR THEATRE',
    'Bier, frisdrank en mixdrankjes. Betalen met munten.',
    '5 MIN',
  ),
  KaartPunt(
    'WATER',
    Offset(892, 485),
    'WATERPUNT RED',
    'Gratis water. Neem je eigen flesje mee.',
    '2 MIN',
  ),
  KaartPunt(
    'WATER',
    Offset(718, 600),
    'WATERPUNT GOLD',
    'Gratis water. Neem je eigen flesje mee.',
    '4 MIN',
  ),
  KaartPunt(
    'WATER',
    Offset(1060, 395),
    'WATERPUNT PURPLE',
    'Gratis water. Neem je eigen flesje mee.',
    '3 MIN',
  ),
  KaartPunt(
    'WC',
    Offset(690, 525),
    'TOILETTEN MAGENTA',
    'Wachttijd ongeveer 5 minuten.',
    '5 MIN',
  ),
  KaartPunt(
    'WC',
    Offset(805, 592),
    'TOILETTEN YELLOW',
    'Wachttijd ongeveer 8 minuten.',
    '2 MIN',
  ),
  KaartPunt(
    'WC',
    Offset(1110, 472),
    'TOILETTEN RED',
    'Wachttijd ongeveer 10 minuten.',
    '1 MIN',
  ),
  KaartPunt(
    'EHBO',
    Offset(655, 470),
    'EHBO-POST WEST',
    'Altijd open. Bij nood: gebruik de SOS-knop.',
    '6 MIN',
  ),
  KaartPunt(
    'EHBO',
    Offset(1125, 620),
    'EHBO-POST RED',
    'Altijd open. Bij nood: gebruik de SOS-knop.',
    '1 MIN',
  ),
];

/// Kleur en pictogram per soort punt.
const puntStijl = {
  'ETEN': (DQ.yellow, 'Eten', 'ETEN'),
  'DRINKEN': (DQ.orange, 'Drinken', 'BAR'),
  'WATER': (DQ.cyan, 'Waterpunt', 'WATERPUNT'),
  'WC': (DQ.lime, 'Wc', 'TOILET'),
  'EHBO': (Colors.white, 'EHBO', 'EHBO'),
};

class FestivalKaart extends StatelessWidget {
  const FestivalKaart({
    super.key,
    this.filter = 'STAGES',
    this.selected = '',
    this.onSelect,
  });

  final String filter; // welke filterknop actief is
  final String selected; // welke stage geselecteerd is
  final ValueChanged<String>? onSelect;

  static const _afbeelding = 'assets/images/Festival kaart naam.png';
  static const _imgW = 1337.0;
  static const _imgH = 1176.0;
  static const _jij = Offset(915, 640); // "je bent hier"

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _imgW / _imgH,
      child: LayoutBuilder(
        builder: (context, box) {
          final sx = box.maxWidth / _imgW;
          final sy = box.maxHeight / _imgH;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(_afbeelding, fit: BoxFit.fill),
              ),

              // Stages: onzichtbare knoppen boven elke stage
              for (final s in kaartStages)
                Positioned(
                  left: s.vak.left * sx,
                  top: s.vak.top * sy,
                  width: s.vak.width * sx,
                  height: s.vak.height * sy,
                  child: Tap(
                    onTap: () {
                      onSelect?.call(s.naam);
                      toonStageInfo(context, s);
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected == s.naam
                              ? Colors.white
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

              // Eten, water, wc, EHBO
              for (final p in kaartPunten.where(
                (p) =>
                    filter == '' ||
                    filter == p.soort ||
                    (p.soort == 'EHBO' && filter != 'STAGES'),
              ))
                Positioned(
                  left: p.plek.dx * sx - 6,
                  top: p.plek.dy * sy - 6,
                  child: Opacity(
                    opacity: 1,
                    child: Tap(
                      onTap: () => toonPuntInfo(context, p),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: puntStijl[p.soort]!.$1,
                          border: Border.all(color: DQ.dark, width: 0.8),
                        ),
                        child: Picto(
                          puntStijl[p.soort]!.$2,
                          size: 8,
                          color: DQ.dark,
                        ),
                      ),
                    ),
                  ),
                ),

              // Crew
              _crew(1000 * sx, 640 * sy, 'MA', DQ.lime),
              _crew(690 * sx, 612 * sy, 'EM', DQ.cyan),

              // Je bent hier
              Positioned(
                left: _jij.dx * sx - 7,
                top: _jij.dy * sy - 7,
                child: Container(
                  width: 14,
                  height: 14,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0x55FF2134),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: DQ.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _crew(double x, double y, String letters, Color kleur) => Positioned(
    left: x - 6,
    top: y - 6,
    child: Container(
      width: 12,
      height: 12,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kleur,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Text(letters, style: inter(4, color: DQ.dark)),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  INFO-SCHERMEN die omhoog schuiven
// ─────────────────────────────────────────────────────────────

void toonStageInfo(BuildContext context, KaartStage s) {
  _toonInfo(
    context,
    kleur: s.kleur,
    kicker: 'STAGE',
    titel: s.naam,
    blokken: [('NU LIVE', s.nu), ('DAARNA', s.straks)],
    regels: [('Menigde', 'DRUKTE', s.drukte), ('Navigatie', 'LOPEN', s.lopen)],
  );
}

void toonPuntInfo(BuildContext context, KaartPunt p) {
  final stijl = puntStijl[p.soort]!;
  _toonInfo(
    context,
    kleur: stijl.$1,
    kicker: stijl.$3,
    titel: p.titel,
    tekst: p.info,
    regels: [('Navigatie', 'LOPEN', p.lopen)],
  );
}

void _toonInfo(
  BuildContext context, {
  required Color kleur,
  required String kicker,
  required String titel,
  String? tekst,
  List<(String, String)> blokken = const [],
  List<(String, String, String)> regels = const [],
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: DQ.dark,
    shape: const RoundedRectangleBorder(),
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 6, color: kleur),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(kicker, style: inter(9, color: kleur, spacing: 2)),
                const SizedBox(height: 6),
                Text(
                  titel,
                  style: bc(
                    40,
                    height: 0.9,
                    spacing: -1.2,
                    color: Colors.white,
                  ),
                ),
                if (tekst != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    tekst,
                    style: inter(
                      11,
                      weight: FontWeight.w500,
                      height: 1.5,
                      color: const Color(0xFFAAAAAA),
                    ),
                  ),
                ],
                if (blokken.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      for (final (i, (label, waarde)) in blokken.indexed) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: DQ.line),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  label,
                                  style: inter(
                                    7,
                                    spacing: 1.2,
                                    color: i == 0 ? kleur : DQ.muted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  waarde,
                                  style: bc(18, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                for (final (picto, label, waarde) in regels)
                  Container(
                    height: 44,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: DQ.line)),
                    ),
                    child: Row(
                      children: [
                        Picto(picto, size: 16),
                        const SizedBox(width: 10),
                        Text(
                          label,
                          style: inter(8, spacing: 1, color: DQ.muted),
                        ),
                        const Spacer(),
                        Text(waarde, style: bc(16, color: Colors.white)),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Tap(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 50,
                    color: kleur,
                    alignment: Alignment.center,
                    child: Text(
                      'SLUITEN',
                      style: inter(
                        10,
                        color: kleur.computeLuminance() > 0.4
                            ? DQ.dark
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
