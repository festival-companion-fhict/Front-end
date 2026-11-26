import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/dq_theme.dart';
import '../widgets/common.dart';

/// Scherm 6: SOS – "WAAR HEB JE HULP BIJ?".
class EmergencySheet extends StatefulWidget {
  const EmergencySheet({super.key, required this.close});

  final VoidCallback close;

  @override
  State<EmergencySheet> createState() => _EmergencySheetState();
}

class _EmergencySheetState extends State<EmergencySheet> {
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ColoredBox(
          color: const Color(0xEE000000),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: 0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              builder: (_, t, child) => FractionalTranslation(
                translation: Offset(0, t),
                child: child,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                decoration: const BoxDecoration(
                  color: DQ.red,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40FF2134),
                      blurRadius: 100,
                      offset: Offset(0, -30),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: HazardStripes(height: 8),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        30,
                        20,
                        math.max(22, bottom + 12),
                      ),
                      child: _sent ? _sentContent() : _askContent(),
                    ),
                    Positioned(
                      right: 15,
                      top: 18,
                      child: OutlineSquare(
                        icon: LucideIcons.x,
                        size: 40,
                        borderColor: const Color(0x77FFFFFF),
                        iconColor: Colors.white,
                        onTap: widget.close,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _symbol(Object icon) => Transform.rotate(
    angle: -4 * math.pi / 180,
    child: Container(
      width: 65,
      height: 65,
      color: DQ.dark,
      child: DqIcon(icon, size: 30, color: Colors.white),
    ),
  );

  Widget _askContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      // Infovak: bij levensgevaar eerst zelf 112 bellen
      // (ruimte erboven, zodat het kruisje er niet overheen valt)
      const SizedBox(height: 52),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: DQ.dark,
          border: Border(left: BorderSide(color: DQ.yellow, width: 4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DqIcon('Info', size: 22, color: DQ.yellow),
            const SizedBox(width: 12),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Levensgevaarlijk? ',
                      style: inter(12, color: DQ.yellow),
                    ),
                    const TextSpan(
                      text:
                          'Bel eerst zelf 112. Gebruik daarna SOS, zodat het team op het terrein weet waar je bent.',
                    ),
                  ],
                ),
                style: inter(
                  12,
                  weight: FontWeight.w500,
                  height: 1.45,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Text('NOODSIGNAAL', style: inter(8, spacing: 2, color: Colors.white)),
      const SizedBox(height: 8),
      Text(
        'WAAR HEB JE\nHULP BIJ?',
        style: bc(
          58,
          italic: true,
          height: 0.82,
          spacing: -2,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 14),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Text(
          'Je locatie wordt direct naar het hulpteam gestuurd.',
          style: inter(
            11,
            weight: FontWeight.w500,
            height: 1.5,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 18),
      _Option(
        icon: 'EHBO',
        title: 'MEDISCH',
        sub: 'EHBO-TEAM',
        dark: false,
        onTap: () => setState(() => _sent = true),
      ),
      _Option(
        icon: 'Security',
        title: 'BEVEILIGING',
        sub: 'VEILIGHEIDSTEAM',
        dark: true,
        onTap: () => setState(() => _sent = true),
      ),
    ],
  );

  Widget _sentContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Align(alignment: Alignment.centerLeft, child: _symbol(LucideIcons.check)),
      const SizedBox(height: 18),
      Text(
        'SIGNAAL ONTVANGEN',
        style: inter(8, spacing: 2, color: Colors.white),
      ),
      const SizedBox(height: 8),
      Text(
        'HULP IS\nONDERWEG',
        style: bc(
          58,
          italic: true,
          height: 0.82,
          spacing: -2,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 14),
      Text(
        'Blijf waar je bent als dat veilig is. Je live locatie is gedeeld.',
        style: inter(
          11,
          weight: FontWeight.w500,
          height: 1.5,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 18),
      Container(
        color: DQ.dark,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VERWACHTE AANKOMST',
              style: inter(
                7,
                weight: FontWeight.w500,
                spacing: 1.3,
                color: Colors.white,
              ),
            ),
            Text('3—5 MIN', style: bc(27, color: DQ.lime)),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Tap(
        onTap: widget.close,
        child: Container(
          height: 50,
          color: DQ.paper,
          alignment: Alignment.center,
          child: Text('BEGREPEN', style: inter(10, color: DQ.dark)),
        ),
      ),
    ],
  );
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.title,
    required this.sub,
    required this.dark,
    required this.onTap,
  });

  final Object icon;
  final String title;
  final String sub;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : DQ.dark;
    return Tap(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: dark ? DQ.dark : DQ.paper,
          border: const Border(bottom: BorderSide(color: DQ.line)),
        ),
        child: Row(
          children: [
            DqIcon(icon, color: fg),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: bc(22, color: fg)),
                  Text(
                    sub,
                    style: inter(
                      7,
                      weight: FontWeight.w500,
                      spacing: 1,
                      color: fg,
                    ),
                  ),
                ],
              ),
            ),
            DqIcon('Pijl_rechts', color: fg),
          ],
        ),
      ),
    );
  }
}
