import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../theme/dq_theme.dart';
import 'common.dart';

/// Het DEFQON.1-logo als tekst.
class Brand extends StatelessWidget {
  const Brand({super.key, this.color = Colors.white, this.showSub = false, this.onTap, this.center = true});

  final Color color;
  final bool showSub;
  final bool center;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: Transform(
        transform: skew(-5),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: center ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('DEFQON', style: bc(27, color: color, spacing: -1.4, height: 0.9)),
            Text(
              '.1',
              style: bc(27, color: DQ.red, weight: FontWeight.w700, height: 0.9),
            ),
            if (showSub) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'WARRIOR NETWORK',
                  style: inter(
                    7,
                    weight: FontWeight.w700,
                    spacing: 1.2,
                    color: color == Colors.white ? const Color(0xFFAAAAAA) : color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bovenbalk: LIVE-knop, logo en profielknop.
class DqHeader extends StatelessWidget {
  const DqHeader({super.key, required this.go, required this.openProfile, required this.openStart});

  final Go go;
  final VoidCallback openProfile;
  final VoidCallback openStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xF00B0B0B),
        border: Border(bottom: BorderSide(color: Color(0xFF343434))),
      ),
      child: Row(
        children: [
          // Knop terug naar het startscherm
          Tap(
            onTap: openStart,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                border: Border.all(color: const Color(0xFF3B3B3B)),
              ),
              child: const Picto('Pijl_links', size: 20),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              border: Border.all(color: const Color(0xFF3B3B3B)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PulseDot(),
                const SizedBox(height: 3),
                Text('LIVE', style: inter(7, spacing: 0.5, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Brand(onTap: () => go(DqPage.home))),
          const SizedBox(width: 64),
          ProfileButton(onTap: openProfile),
        ],
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tap(
    onTap: onTap,
    child: Container(
      width: 44,
      height: 44,
      color: DQ.lime,
      child: const Picto('Gebruiker', size: 21, color: DQ.dark),
    ),
  );
}

/// Rood stipje dat zachtjes "pulseert".
class PulseDot extends StatefulWidget {
  const PulseDot({super.key, this.color = DQ.red, this.size = 7});

  final Color color;
  final double size;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, _) {
      // 0 → 0.5: ring groeit en vervaagt, 0.5 → 1: terug.
      final t = _c.value < 0.5 ? _c.value * 2 : (1 - _c.value) * 2;
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.16 * (1 - t)),
              spreadRadius: 4 + 4 * t,
            ),
          ],
        ),
      );
    },
  );
}

/// Lichte strook onder de header met tijd, drukte en weer.
class LiveStrip extends StatefulWidget {
  const LiveStrip({super.key});

  @override
  State<LiveStrip> createState() => _LiveStripState();
}

class _LiveStripState extends State<LiveStrip> {
  DateTime _now = DateTime.now();
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => setState(() => _now = DateTime.now()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String two(int n) => n.toString().padLeft(2, '0');
    Widget divider() => Container(width: 1, height: 12, color: const Color(0xFFAAAAAA));
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: const BoxDecoration(
        color: Color(0xFFF0EDE7),
        border: Border(bottom: BorderSide(color: DQ.dark)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: DQ.red, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text('LIVE UPDATE', style: inter(7, color: DQ.red, spacing: 1)),
          const SizedBox(width: 10),
          Text('${two(_now.hour)}:${two(_now.minute)}', style: bc(14, color: DQ.dark)),
          const SizedBox(width: 10),
          divider(),
          const SizedBox(width: 10),
          Text('RED: ZEER DRUK', style: inter(7, color: DQ.dark)),
          const Spacer(),
          divider(),
          const SizedBox(width: 10),
          const DqIcon('Bewolkt', size: 13, color: DQ.dark),
          const SizedBox(width: 3),
          Text('24°C', style: inter(7, color: DQ.dark)),
        ],
      ),
    );
  }
}

/// Onderste navigatiebalk met 5 tabs.
class DqNav extends StatelessWidget {
  const DqNav({super.key, required this.active, required this.go});

  final DqPage active;
  final Go go;

  static const _items = [
    (DqPage.home, 'HOME', ''),
    (DqPage.map, 'MAP', 'Kaart'),
    (DqPage.lineup, 'SCHEMA', 'calendar'),
    (DqPage.report, 'MELDEN', 'Melden'),
    (DqPage.news, 'NIEUWS', 'Info'),
    (DqPage.crew, 'CREW', 'Crew'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      height: 72 + bottom,
      padding: EdgeInsets.only(left: 7, right: 7, bottom: bottom),
      decoration: const BoxDecoration(
        color: Color(0xF50A0A0A),
        border: Border(top: BorderSide(color: Color(0xFF3A3A3A))),
      ),
      child: Row(
        children: [
          for (final (page, label, icon) in _items)
            Expanded(
              child: Tap(
                onTap: () => go(page),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (active == page) Positioned(top: -1, child: Container(width: 35, height: 4, color: DQ.red)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        page == DqPage.home
                            ? DqIcon(LucideIcons.house, size: 20, color: active == page ? DQ.red : const Color(0xFF5D5D5D))
                            : Picto(icon, size: 20, color: active == page ? DQ.red : const Color(0xFF5D5D5D)),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: inter(7, spacing: 0.5, color: active == page ? Colors.white : const Color(0xFF5D5D5D)),
                        ),
                      ],
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

/// De rode SOS-knop rechtsonder.
class SosButton extends StatelessWidget {
  const SosButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tap(
    onTap: onTap,
    child: Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: const BoxDecoration(
        color: DQ.red,
        boxShadow: [BoxShadow(color: Color(0xFF641019), offset: Offset(6, 6))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DqIcon('Alert', size: 18, color: Colors.white),
          const SizedBox(width: 6),
          Text('SOS', style: inter(9, color: Colors.white)),
        ],
      ),
    ),
  );
}
