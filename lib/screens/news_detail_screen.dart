import 'package:flutter/material.dart';

import '../data/festival_data.dart';
import '../data/taal.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';

/// Opent de nieuwspagina van één bericht.
void openNieuws(BuildContext context, NewsItem item) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => NewsDetailScreen(item: item)));
}

/// De categorieën uit de database (tabel aankondigingen).
const nieuwsSoorten = [
  'PROGRAMMA',
  'VERVOER',
  'WEER',
  'VEILIGHEID',
  'ALGEMEEN',
];

/// Kleur per soort nieuws.
Color nieuwsKleur(String categorie) => switch (categorie) {
  'BELANGRIJK' => DQ.red,
  'PROGRAMMA' => DQ.yellow,
  'VERVOER' => DQ.cyan,
  'WEER' => DQ.aqua,
  'VEILIGHEID' => DQ.orange,
  'ALGEMEEN' => DQ.paper,
  'ARTIESTEN' => DQ.fuchsia,
  _ => DQ.muted,
};

/// Scherm 8b: één nieuwsbericht.
class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key, required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    final kleur = nieuwsKleur(item.category);
    void terug() => Navigator.of(context).pop();

    return Scaffold(
      backgroundColor: DQ.ink,
      body: SafeArea(
        child: Column(
          children: [
            // Bovenbalk met terug-knop
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: DQ.line)),
              ),
              child: Row(
                children: [
                  OutlineSquare(
                    icon: 'Pijl_links',
                    iconColor: Colors.white,
                    onTap: terug,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(t('LIVE NIEUWS'), style: bc(18, spacing: 1)),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    // Categorie + tijd
                    Row(
                      children: [
                        Container(
                          color: kleur,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          child: Text(
                            t(item.category),
                            style: inter(
                              8,
                              spacing: 1.2,
                              color: kleur.computeLuminance() > 0.4
                                  ? DQ.dark
                                  : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${t('VANDAAG')} · ${item.time}',
                          style: inter(8, spacing: 1.2, color: DQ.muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Titel
                    Text(
                      item.title.toUpperCase(),
                      style: bc(46, height: 0.9, spacing: -1.5),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(height: 5, width: 60, color: kleur),
                    ),
                    const SizedBox(height: 18),
                    // Korte samenvatting
                    Text(
                      item.text,
                      style: inter(
                        14,
                        weight: FontWeight.w600,
                        height: 1.45,
                        color: Colors.white,
                      ),
                    ),
                    // Het hele verhaal
                    if (item.body.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        item.body,
                        style: inter(
                          12,
                          weight: FontWeight.w500,
                          height: 1.6,
                          color: const Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    // Terug-knop onderaan
                    Tap(
                      onTap: terug,
                      child: Container(
                        height: 52,
                        color: DQ.paper,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            const DqIcon(
                              'Pijl_links',
                              size: 18,
                              color: DQ.dark,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              t('TERUG NAAR NIEUWS'),
                              style: inter(10, color: DQ.dark),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}