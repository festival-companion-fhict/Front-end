import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../data/festival_data.dart';
import '../data/festivaltijd.dart';
import '../data/instellingen.dart';
import '../data/taal.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';
import '../widgets/festival_kaart.dart';
import 'map_screen.dart';
import 'news_detail_screen.dart';

/// Scherm 5: artiestpagina. Laat de act zien die in [gekozenAct] staat.
class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key, required this.go});

  final Go go;

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  String _tab = 'INFO';

  @override
  Widget build(BuildContext context) {
    final act = gekozenAct;
    if (act == null) {
      return Center(
        child: Text(
          t('Selecteer eerst een artiest uit de line-up.'),
          style: inter(11, weight: FontWeight.w600, color: DQ.muted),
        ),
      );
    }

    final width = MediaQuery.sizeOf(context).width;
    final nameSize = width <= 390 ? 56.0 : (width * 0.18).clamp(59.0, 84.0);
    final herinnering = Instellingen.herinneringen.contains(act.sleutel);
    final dagActs = lineup.where((a) => a.dag == act.dag).toList();
    final nummer = (dagActs.indexOf(act) + 1).toString().padLeft(2, '0');

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 520,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              children: [
                const ColoredBox(color: DQ.dark),
                const GreyImage('assets/images/defqon-fire.jpg', contrast: 1.3),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0x55FF2134), Colors.transparent],
                      stops: [0, 0.7],
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x22000000), DQ.ink],
                      stops: [0.25, 0.98],
                    ),
                  ),
                ),
                Positioned(
                  right: -15,
                  top: 40,
                  child: OutlineText(
                    nummer,
                    style: bc(180),
                    color: const Color(0x28FFFFFF),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 16,
                  child: OutlineSquare(
                    icon: 'Pijl_links',
                    borderColor: const Color(0x70FFFFFF),
                    background: const Color(0x990B0B0B),
                    iconColor: Colors.white,
                    iconSize: 22,
                    onTap: () => widget.go(DqPage.lineup),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 16,
                  child: Tap(
                    onTap: () async {
                      // Zelfde hartje als in het SCHEMA (MIJN SCHEMA)
                      await Instellingen.wisselBewaard(act.sleutel);
                      setState(() {});
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0x990B0B0B),
                        border: Border.all(color: const Color(0x70FFFFFF)),
                      ),
                      child: DqIcon(
                        Instellingen.bewaard.contains(act.sleutel)
                            ? 'Vol_hart'
                            : 'Hart',
                        color: DQ.red,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  right: 15,
                  bottom: 26,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FestivalTijd.isLive(act) ? t('LIVE NU') : 'LIVE ACT',
                        style: inter(
                          9,
                          color: DQ.lime,
                          weight: FontWeight.w800,
                          spacing: 2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        act.artist,
                        style: bc(
                          nameSize,
                          italic: true,
                          height: 0.82,
                          spacing: -3.5,
                          shadows: const [Shadow(offset: Offset(4, 4))],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Schuin lint met genres
          Transform.rotate(
            angle: -1 * 3.14159 / 180,
            child: Container(
              height: 34,
              color: genreKleur(act.genre),
              alignment: Alignment.centerLeft,
              child: Text(
                '${t(act.genre)} · ' * 8,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.clip,
                style: bc(15, color: DQ.dark, spacing: 1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 22, 15, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: Color(0xFF393939)),
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _MetaCell(
                            'WANNEER',
                            '${act.dag.substring(0, 3)} · ${act.time}',
                          ),
                        ),
                        Expanded(child: _MetaCell('WAAR', act.kaartNaam)),
                        Tap(
                          // Staat de stage niet op de kaart? Dan geen route.
                          onTap: opKaart(act.kaartNaam)
                              ? () {
                                  kaartStartSelectie = act.kaartNaam;
                                  kaartStartRoute = true;
                                  widget.go(DqPage.map);
                                }
                              : null,
                          child: Container(
                            color: opKaart(act.kaartNaam)
                                ? DQ.red
                                : const Color(0xFF2A2A2A),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const DqIcon(
                                  'Navigatie',
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  t('ROUTE'),
                                  style: inter(9, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    for (final tab in const ['INFO', 'NIEUWS', 'OPTREDENS'])
                      Padding(
                        padding: const EdgeInsets.only(right: 22),
                        child: Tap(
                          onTap: () => setState(() => _tab = tab),
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _tab == tab
                                      ? DQ.red
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              t(tab),
                              style: bc(
                                17,
                                color: _tab == tab
                                    ? Colors.white
                                    : const Color(0xFF555555),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                switch (_tab) {
                  'INFO' => _info(act),
                  'NIEUWS' => _nieuws(act),
                  _ => _optredens(act),
                },
                const SizedBox(height: 20),
                Tap(
                  onTap: () async {
                    await Instellingen.wisselHerinnering(act.sleutel);
                    setState(() {});
                  },
                  child: Container(
                    height: 52,
                    color: herinnering ? DQ.lime : const Color(0xFF1A1A1A),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        DqIcon(
                          LucideIcons.bell,
                          color: herinnering ? DQ.dark : Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          t('HERINNER ME 15 MIN VAN TEVOREN'),
                          style: inter(
                            10,
                            color: herinnering ? DQ.dark : Colors.white,
                          ),
                        ),
                        const Spacer(),
                        if (herinnering)
                          const DqIcon(LucideIcons.check, color: DQ.dark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tabblad INFO: de omschrijving van de artiest.
  Widget _info(Act act) => Text(
    act.info.isNotEmpty
        ? act.info
        : Taal.engels
        ? '${act.artist} plays ${t(act.genre).toLowerCase()} at ${act.kaartNaam}, '
              'from ${act.time} to ${act.end}. More info about this act coming soon.'
        : '${act.artist} speelt ${act.genre.toLowerCase()} op ${act.kaartNaam}, '
              'van ${act.time} tot ${act.end}. Meer info over deze act volgt binnenkort.',
    style: inter(
      12,
      weight: FontWeight.w500,
      color: const Color(0xFFAAAAAA),
      height: 1.6,
    ),
  );

  /// Tabblad NIEUWS: berichten over deze artiest.
  Widget _nieuws(Act act) {
    final berichten = news.where((n) => n.artiest == act.artist).toList();
    if (berichten.isEmpty) {
      return Text(
        '${t('Nog geen nieuws over')} ${act.artist}.',
        style: inter(12, weight: FontWeight.w500, color: DQ.muted),
      );
    }
    return Column(
      children: [
        for (final n in berichten)
          Tap(
            onTap: () => openNieuws(context, n),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: DQ.line)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${t(n.category)} · ${n.time}',
                    style: inter(8, spacing: 1, color: nieuwsKleur(n.category)),
                  ),
                  const SizedBox(height: 4),
                  Text(n.title.toUpperCase(), style: bc(18)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Tabblad OPTREDENS: alle keren dat deze artiest speelt.
  Widget _optredens(Act act) {
    final keren = lineup.where((a) => a.artist == act.artist).toList();
    return Column(
      children: [
        for (final k in keren)
          Container(
            height: 52,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: DQ.line)),
            ),
            child: Row(
              children: [
                Container(width: 6, color: stageKleur(k.kaartNaam)),
                const SizedBox(width: 12),
                SizedBox(width: 70, child: Text(k.dag, style: bc(17))),
                Text(
                  '${k.time} – ${k.end}',
                  style: inter(10, color: Colors.white),
                ),
                const Spacer(),
                Text(k.kaartNaam, style: inter(9, color: DQ.muted)),
              ],
            ),
          ),
      ],
    );
  }
}

class _MetaCell extends StatelessWidget {
  const _MetaCell(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 14),
    decoration: const BoxDecoration(
      border: Border(right: BorderSide(color: Color(0xFF393939))),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t(label),
          style: inter(
            7,
            weight: FontWeight.w500,
            spacing: 1.2,
            color: DQ.muted,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: bc(17)),
      ],
    ),
  );
}
