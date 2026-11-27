import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../data/festival_data.dart';
import '../data/taal.dart';
import '../theme/dq_theme.dart';
import '../data/instellingen.dart';
import '../widgets/common.dart';
import 'map_screen.dart';
import 'news_detail_screen.dart';

/// Scherm 8: LIVE NIEUWS.
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key, required this.go});

  final Go go;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String _filter = 'ALLES'; // welke soort nieuws je ziet

  @override
  Widget build(BuildContext context) {
    final berichten = news
        .where(
          (n) =>
              _filter == 'ALLES' ||
              n.category == _filter ||
              (_filter == 'ARTIESTEN' && n.artiest != ''),
        )
        .toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeading(
            kicker: 'LAATST BIJGEWERKT · NU',
            title: 'LIVE NIEUWS',
            action: OutlineSquare(
              icon: LucideIcons.bell,
              onTap: () => _toonMeldingen(context),
            ),
          ),
          // Belangrijke melding
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(color: DQ.red),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  right: -8,
                  bottom: -80,
                  child: Text(
                    '!',
                    style: bc(180, color: const Color(0x11000000)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const DqIcon('Alert', size: 18, color: Colors.white),
                          const SizedBox(width: 7),
                          Text(
                            '${t('BELANGRIJK')} · 18:47',
                            style: inter(7, spacing: 1.2, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Text(
                          t('EXTRA WATERPUNTEN OPEN'),
                          style: bc(29, height: 0.95, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 340),
                        child: Text(
                          t('Door de warmte zijn extra tappunten geopend naast RED en BLUE. Drink voldoende.'),
                          style: inter(
                            10,
                            weight: FontWeight.w500,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Tap(
                        onTap: () {
                          kaartStartFilter =
                              'WATER'; // kaart opent met de waterpunten
                          widget.go(DqPage.map);
                        },
                        child: Container(
                          color: DQ.dark,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                t('TOON OP KAART'),
                                style: inter(8, color: Colors.white),
                              ),
                              const SizedBox(width: 24),
                              const DqIcon(
                                LucideIcons.arrowRight,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          // Live regel
          Container(
            constraints: const BoxConstraints(minHeight: 67),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              border: Border.all(color: const Color(0xFF393939)),
            ),
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: DQ.lime,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Color(0x18BDFC16), spreadRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIVE · RED STAGE',
                        style: inter(
                          7,
                          weight: FontWeight.w500,
                          spacing: 1,
                          color: DQ.lime,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(t('POWER HOUR IS 10 MIN VERTRAAGD'), style: bc(15)),
                    ],
                  ),
                ),
                Text(
                  '18:42',
                  style: inter(8, weight: FontWeight.w500, color: DQ.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Filterknoppen
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final f in ['ALLES', ...nieuwsSoorten, 'ARTIESTEN'])
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: Tap(
                      onTap: () => setState(() => _filter = f),
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: _filter == f ? DQ.paper : Colors.transparent,
                          border: Border.all(
                            color: _filter == f ? DQ.paper : DQ.line2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (f != 'ALLES') ...[
                              Container(
                                width: 8,
                                height: 8,
                                color: nieuwsKleur(f),
                              ),
                              const SizedBox(width: 7),
                            ],
                            Text(
                              t(f),
                              style: inter(
                                9,
                                weight: FontWeight.w800,
                                color: _filter == f ? DQ.dark : DQ.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: const Color(0xFF383838)),
          for (final item in berichten)
            Tap(
              onTap: () => openNieuws(context, item),
              child: Container(
                constraints: const BoxConstraints(minHeight: 91),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF383838))),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.time, style: inter(8, color: DQ.red)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t(item.category),
                            style: inter(
                              7,
                              spacing: 1,
                              color: nieuwsKleur(item.category),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(item.title, style: bc(19)),
                          const SizedBox(height: 3),
                          Text(
                            item.text,
                            style: inter(
                              9,
                              weight: FontWeight.w500,
                              height: 1.4,
                              color: DQ.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: DqIcon(
                        LucideIcons.chevronRight,
                        size: 16,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Bel-knop: kies welke pushberichten je wilt krijgen.
void _toonMeldingen(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: DQ.dark,
    shape: const RoundedRectangleBorder(),
    isScrollControlled: true, // mag hoger worden; scrollen als het niet past
    builder: (context) => StatefulBuilder(
      builder: (context, setSheet) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 6, color: DQ.red),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      t('PUSHBERICHTEN'),
                      style: inter(9, color: DQ.red, spacing: 2),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t('MELDINGEN'),
                      style: bc(40, height: 0.9, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t('Kies over welk nieuws je een melding op je telefoon wilt krijgen.'),
                      style: inter(
                        11,
                        weight: FontWeight.w500,
                        height: 1.5,
                        color: const Color(0xFFAAAAAA),
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final soort in [
                      'BELANGRIJK',
                      ...nieuwsSoorten,
                      'ARTIESTEN',
                    ])
                      Container(
                        height: 54,
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: DQ.line)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: nieuwsKleur(soort),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                t(soort),
                                style: bc(18, color: Colors.white),
                              ),
                            ),
                            Schakelaar(
                              aan: Instellingen.aan(soort),
                              onChanged: (waarde) async {
                                await Instellingen.zet(soort, waarde);
                                setSheet(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Tap(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 50,
                        color: DQ.paper,
                        alignment: Alignment.center,
                        child: Text(t('KLAAR'), style: inter(10, color: DQ.dark)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
