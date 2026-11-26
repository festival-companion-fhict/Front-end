import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';

const _ink2 = Color(0xFF15111A);

/// Scherm 2: home – "Je bent nu bij RED STAGE".
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.go});

  final Go go;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0D0B12),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 25 + 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Presence(go: go),
            const _LiveCard(),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          color: DQ.aqua,
                          icon: 'Crew',
                          label: 'DRUKTE',
                          value: 'ZEER DRUK',
                          sub: '92% capaciteit',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _Metric(
                          color: DQ.fuchsia,
                          icon: LucideIcons.volume2,
                          label: 'GELUID',
                          value: '102 DB',
                          sub: 'Oordoppen aangeraden',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _UpNext(onTap: () => go(DqPage.artist)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 25, 2, 10),
                    child: Row(
                      children: [
                        Text('VLAKBIJ JOU', style: bc(21)),
                        const Spacer(),
                        Tap(
                          onTap: () => go(DqPage.map),
                          child: Row(
                            children: [
                              Text('OP KAART', style: inter(7, color: DQ.acid)),
                              const SizedBox(width: 4),
                              const DqIcon('Pijl_rechts', size: 13, color: DQ.acid),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _Nearby(DQ.aqua, 'Waterpunt', 'WATER', '1 min · rustig', () => go(DqPage.map)),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _Nearby(DQ.acid, 'Wc', 'TOILET', '2 min · druk', () => go(DqPage.map)),
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
                  const _StageAlert(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Presence extends StatelessWidget {
  const _Presence({required this.go});

  final Go go;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DQ.acid,
      constraints: const BoxConstraints(minHeight: 176),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomLeft,
        children: [
          const Positioned(right: -80, top: -90, child: Ring(size: 180, width: 34, color: Color(0xE65A19FF))),
          Positioned(
            right: 9,
            bottom: -45,
            child: Text('01', style: bc(140, color: const Color(0x285A19FF))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const DqIcon('Target', size: 15, color: _ink2),
                          const SizedBox(width: 5),
                          Text('JE BENT NU BIJ', style: inter(8, color: _ink2, spacing: 1.5)),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text('RED\nSTAGE', style: bc(58, color: _ink2, height: 0.8, spacing: -2)),
                      const SizedBox(height: 4),
                      Text(
                        'Locatie live · nauwkeurig tot 12 meter',
                        style: inter(7, color: _ink2, weight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                Tap(
                  onTap: () => go(DqPage.map),
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(border: Border.all(color: _ink2)),
                    child: Row(
                      children: [
                        Text('WIJZIG STAGE', style: inter(7, color: _ink2)),
                        const SizedBox(width: 7),
                        const DqIcon('Kaart', size: 15, color: _ink2),
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
              gradient: LinearGradient(colors: [Color(0x805A19FF), Colors.transparent], stops: [0, 0.7]),
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
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                  child: Row(
                    children: [
                      const PulseRing(),
                      const SizedBox(width: 7),
                      Text('LIVE NOW', style: inter(8, spacing: 1, color: Colors.white)),
                    ],
                  ),
                ),
                const Spacer(),
                Text('18:42', style: bc(20)),
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
                      Text('RED STAGE · 18:00—19:10', style: inter(8, color: DQ.acid, spacing: 1.3)),
                      const SizedBox(height: 5),
                      Text(
                        'POWER\nHOUR',
                        style: bc(
                          58,
                          height: 0.8,
                          spacing: -2,
                          shadows: const [Shadow(color: DQ.impact, offset: Offset(3, 3))],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        color: DQ.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                        child: Text('10 MIN VERTRAAGD', style: inter(7, spacing: 1, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                // Groot aftelcijfer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('28', style: bc(76, height: 0.9, color: DQ.acid)),
                    Text('MIN LEFT', style: inter(9, color: DQ.acid, spacing: 1)),
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
                  child: FractionallySizedBox(widthFactor: 0.61, child: Container(color: DQ.acid)),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('42 MIN', style: inter(7, color: const Color(0xFFAAAAAA))),
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
  const _Metric({required this.color, required this.icon, required this.label, required this.value, required this.sub});

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
            Text(label, style: inter(7, color: _ink2, spacing: 1.2)),
          ],
        ),
        const Spacer(),
        Text(value, style: bc(25, color: _ink2, height: 0.9)),
        const SizedBox(height: 4),
        Text(
          sub,
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
                  Text('UP NEXT · 19:10', style: inter(7, color: DQ.acid, spacing: 1.1)),
                  const SizedBox(height: 5),
                  Text('SUB ZERO PROJECT', style: bc(21, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(
                    'Begint over 28 minuten',
                    style: inter(7, weight: FontWeight.w500, color: const Color(0xFF7F7988)),
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
                child: const DqIcon('Pijl_rechts', size: 22, color: Color(0xFF14111A)),
              ),
            ],
          ),
          const Spacer(),
          Text(title, style: bc(26, color: const Color(0xFF14111A), height: 1)),
          Text(sub.toUpperCase(), style: inter(6, color: const Color(0xFF14111A), weight: FontWeight.w800)),
        ],
      ),
    ),
  );
}class _StageAlert extends StatelessWidget {
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
                  Text('LIVE UPDATE · 18:38', style: inter(7, color: DQ.orange, spacing: 1)),
                ],
              ),
              const SizedBox(height: 6),
              Text('UITGANG LINKS TIJDELIJK DRUK', style: bc(16)),
              const SizedBox(height: 2),
              Text(
                'Gebruik na de show bij voorkeur de uitgang aan de rechterkant.',
                style: inter(7, weight: FontWeight.w500, color: const Color(0xFF8F8795), height: 1.4),
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
