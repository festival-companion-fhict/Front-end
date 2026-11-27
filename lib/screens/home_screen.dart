import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../data/festival_data.dart';
import '../data/taal.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';
import '../widgets/live.dart';
import 'map_screen.dart';

const _ink2 = Color(0xFF15111A);

/// Scherm 2: home – "Je bent nu bij RED STAGE".
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.go});

  final Go go;

  @override
  Widget build(BuildContext context) {
    void openArtiest(String naam, {String stage = ''}) {
      final act = zoekAct(naam, stage: stage);
      if (act == null) {
        final melding =
            lineupStatus == LineupStatus.loading ||
                lineupStatus == LineupStatus.notLoaded
            ? 'De line-up wordt nog geladen.'
            : 'Deze artiest staat niet in de line-up.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t(melding))));
        return;
      }
      gekozenAct = act;
      go(DqPage.artist);
    }

    return ColoredBox(
      color: const Color(0xFF0D0B12),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 25 + 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Tap(
              onTap: () => openArtiest('POWER HOUR'),
              child: const _LiveCard(),
            ),
            _Presence(go: go),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Tap(
                          onTap: () {
                            kaartStartFilter = 'DRUKTE';
                            go(DqPage.map);
                          },
                          child: const _Metric(
                            color: DQ.aqua,
                            icon: 'Crew',
                            label: 'DRUKTE',
                            value: 'ZEER DRUK',
                            sub: '92% capaciteit',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Tap(
                          onTap: () => _toonOordoppen(context),
                          child: const _Metric(
                            color: DQ.fuchsia,
                            icon: LucideIcons.volume2,
                            label: 'GELUID',
                            value: '102 DB',
                            sub: 'Oordoppen aangeraden',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _UpNext(
                    onTap: () => openArtiest('SUB ZERO PROJECT', stage: 'RED'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 25, 2, 10),
                    child: Row(
                      children: [
                        Text(t('VLAKBIJ JOU'), style: bc(21)),
                        const Spacer(),
                        Tap(
                          onTap: () => go(DqPage.map),
                          child: Row(
                            children: [
                              Text(
                                t('OP KAART'),
                                style: inter(7, color: DQ.acid),
                              ),
                              const SizedBox(width: 4),
                              const DqIcon(
                                'Pijl_rechts',
                                size: 13,
                                color: DQ.acid,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _Nearby(
                          DQ.aqua,
                          'Waterpunt',
                          'WATER',
                          '1 min · rustig',
                          () => go(DqPage.map),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _Nearby(
                          DQ.acid,
                          'Wc',
                          'TOILET',
                          '2 min · druk',
                          () => go(DqPage.map),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _Nearby(
                          const Color(0xFFF3F0F6),
                          'EHBO',
                          'EHBO',
                          '3 min · open',
                          () => go(DqPage.map),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Tap(onTap: () => go(DqPage.news), child: const _StageAlert()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Smalle lime balk: waar je nu bent + knop om te wijzigen.
class _Presence extends StatelessWidget {
  const _Presence({required this.go});

  final Go go;

  @override
  Widget build(BuildContext context) => Tap(
    onTap: () => go(DqPage.map),
    child: Container(
      height: 64,
      color: DQ.acid,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const DqIcon('Target', size: 20, color: _ink2),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t('JE BENT NU BIJ'),
                  style: inter(7, color: _ink2, spacing: 1.2),
                ),
                Text('RED STAGE', style: bc(24, color: _ink2, height: 1)),
              ],
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: _ink2,
            child: Row(
              children: [
                Text(t('WIJZIG'), style: inter(8, color: Colors.white)),
                const SizedBox(width: 6),
                const DqIcon('Kaart', size: 15, color: DQ.acid),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Tip over oordoppen (als je op de GELUID-kaart tikt).
void _toonOordoppen(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: DQ.dark,
    shape: const RoundedRectangleBorder(),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 6, color: DQ.fuchsia),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t('GELUID · 102 DB'),
                  style: inter(9, color: DQ.fuchsia, spacing: 2),
                ),
                const SizedBox(height: 6),
                Text(
                  t('BESCHERM JE OREN'),
                  style: bc(40, height: 0.9, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  t('Boven 100 dB kan je gehoor al na korte tijd beschadigen. ') +
                      t(
                        'Gratis oordoppen haal je bij elke EHBO-post en bij de bars.',
                      ),
                  style: inter(
                    11,
                    weight: FontWeight.w500,
                    height: 1.5,
                    color: const Color(0xFFAAAAAA),
                  ),
                ),
                const SizedBox(height: 16),
                Tap(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 50,
                    color: DQ.fuchsia,
                    alignment: Alignment.center,
                    child: Text(
                      t('OKÉ'),
                      style: inter(10, color: Colors.white),
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

class _LiveCard extends StatelessWidget {
  const _LiveCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFF211433)),
          const GreyImage('assets/images/stage-purple.jpg', contrast: 1.12),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x805A19FF), Colors.transparent],
                stops: [0, 0.7],
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x403814A1), Color(0xFF0D0B12)],
                stops: [0.05, 0.96],
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            top: 14,
            child: Row(
              children: [
                Container(
                  color: DQ.fuchsia,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  child: Row(
                    children: [
                      const PulseRing(),
                      const SizedBox(width: 7),
                      Text(
                        t('LIVE NU'),
                        style: inter(8, spacing: 1, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Klok(style: bc(20)),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RED STAGE · 18:00—19:10',
                        style: inter(8, color: DQ.acid, spacing: 1.3),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'POWER\nHOUR',
                        style: bc(
                          58,
                          height: 0.8,
                          spacing: -2,
                          shadows: const [
                            Shadow(color: DQ.impact, offset: Offset(3, 3)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        color: DQ.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        child: Text(
                          t('10 MIN VERTRAAGD'),
                          style: inter(7, spacing: 1, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                // Groot aftelcijfer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('28', style: bc(76, height: 0.9, color: DQ.acid)),
                    Text(
                      t('MIN NOG'),
                      style: inter(9, color: DQ.acid, spacing: 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 4,
            child: Column(
              children: [
                Container(
                  height: 5,
                  color: const Color(0x30FFFFFF),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.61,
                    child: Container(color: DQ.acid),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '42 MIN',
                      style: inter(7, color: const Color(0xFFAAAAAA)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wit stipje met zachte ring.
class PulseRing extends StatelessWidget {
  const PulseRing({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 7,
    height: 7,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: Color(0x30FFFFFF), spreadRadius: 4)],
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
  });

  final Color color;
  final Object icon;
  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) => Container(
    height: 126,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.zero),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DqIcon(icon, size: 22, color: _ink2),
            const Spacer(),
            Text(t(label), style: inter(7, color: _ink2, spacing: 1.2)),
          ],
        ),
        const Spacer(),
        Text(t(value), style: bc(25, color: _ink2, height: 0.9)),
        const SizedBox(height: 4),
        Text(
          t(sub),
          style: inter(7, color: _ink2, weight: FontWeight.w500),
        ),
      ],
    ),
  );
}

class _UpNext extends StatelessWidget {
  const _UpNext({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tap(
    onTap: onTap,
    child: Container(
      height: 108,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF17131F),
        borderRadius: BorderRadius.zero,
        border: Border.all(color: const Color(0xFF3A3544)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t('HIERNA · 19:10'),
                    style: inter(7, color: DQ.acid, spacing: 1.1),
                  ),
                  const SizedBox(height: 5),
                  Text('SUB ZERO PROJECT', style: bc(21, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(
                    t('Begint over 28 minuten'),
                    style: inter(
                      7,
                      weight: FontWeight.w500,
                      color: const Color(0xFF7F7988),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Transform(
            transform: skew(-5),
            alignment: Alignment.center,
            child: Container(
              width: 69,
              color: DQ.impact,
              alignment: Alignment.center,
              child: Transform(
                transform: skew(5),
                alignment: Alignment.center,
                child: Text('SZP', style: bc(25, color: Colors.white)),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DqIcon('Pijl_rechts', size: 17, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

class _Nearby extends StatelessWidget {
  const _Nearby(this.color, this.icon, this.title, this.sub, this.onTap);

  final Color color;
  final Object icon;
  final String title;
  final String sub;
  final VoidCallback onTap;

  /// Zone-bordje, zoals de bordjes op het festivalterrein.
  @override
  Widget build(BuildContext context) => Tap(
    onTap: onTap,
    child: Container(
      height: 112,
      padding: const EdgeInsets.all(10),
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DqIcon(icon, size: 22, color: const Color(0xFF14111A)),
              const Spacer(),
              // Schuine pijl (45 graden gedraaid)
              Transform.rotate(
                angle: -0.785,
                child: const DqIcon(
                  'Pijl_rechts',
                  size: 22,
                  color: Color(0xFF14111A),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            t(title),
            style: bc(26, color: const Color(0xFF14111A), height: 1),
          ),
          Text(
            t(sub).toUpperCase(),
            style: inter(
              6,
              color: const Color(0xFF14111A),
              weight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}

class _StageAlert extends StatelessWidget {
  const _StageAlert();

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 82),
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: const Color(0xFF211623),
      borderRadius: BorderRadius.zero,
      border: Border.all(color: const Color(0xFF45354A)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const DqIcon('Alert', size: 14, color: DQ.orange),
                  const SizedBox(width: 5),
                  Text(
                    'LIVE UPDATE · 18:38',
                    style: inter(7, color: DQ.orange, spacing: 1),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(t('UITGANG LINKS TIJDELIJK DRUK'), style: bc(16)),
              const SizedBox(height: 2),
              Text(
                t(
                  'Gebruik na de show bij voorkeur de uitgang aan de rechterkant.',
                ),
                style: inter(
                  7,
                  weight: FontWeight.w500,
                  color: const Color(0xFF8F8795),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        const DqIcon(LucideIcons.chevronRight, size: 16),
      ],
    ),
  );
}
