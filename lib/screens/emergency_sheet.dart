import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/dq_theme.dart';
import '../widgets/common.dart';

/// Scherm 6: SOS – "WHAT DO YOU NEED?".
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
              builder: (_, t, child) => FractionalTranslation(translation: Offset(0, t), child: child),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                decoration: const BoxDecoration(
                  color: DQ.red,
                  boxShadow: [BoxShadow(color: Color(0x40FF2134), blurRadius: 100, offset: Offset(0, -30))],
                ),
                child: Stack(
                  children: [
                    const Positioned(left: 0, right: 0, top: 0, child: HazardStripes(height: 8)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, math.max(22, bottom + 12)),
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
      Align(alignment: Alignment.centerLeft, child: _symbol('Alert')),
      const SizedBox(height: 18),
      Text('EMERGENCY SIGNAL', style: inter(8, spacing: 2, color: Colors.white)),
      const SizedBox(height: 8),
      Text('WHAT DO\nYOU NEED?', style: bc(58, italic: true, height: 0.82, spacing: -2, color: Colors.white)),
      const SizedBox(height: 14),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Text(
          'Your current location will be sent directly to the response team.',
          style: inter(11, weight: FontWeight.w500, height: 1.5, color: Colors.white),
        ),
      ),
      const SizedBox(height: 18),
      _Option(
        icon: 'EHBO',
        title: 'MEDICAL',
        sub: 'FIRST AID TEAM',
        dark: false,
        onTap: () => setState(() => _sent = true),
      ),
      _Option(
        icon: 'Security',
        title: 'SECURITY',
        sub: 'SAFETY TEAM',
        dark: true,
        onTap: () => setState(() => _sent = true),
      ),
      const SizedBox(height: 16),
      Center(
        child: Text(
          'LIFE-THREATENING? ALWAYS CALL 112',
          style: inter(7, weight: FontWeight.w800, spacing: 1, color: Colors.white),
        ),
      ),
    ],
  );

  Widget _sentContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Align(alignment: Alignment.centerLeft, child: _symbol(LucideIcons.check)),
      const SizedBox(height: 18),
      Text('SIGNAL RECEIVED', style: inter(8, spacing: 2, color: Colors.white)),
      const SizedBox(height: 8),
      Text('HELP IS\nMOVING', style: bc(58, italic: true, height: 0.82, spacing: -2, color: Colors.white)),
      const SizedBox(height: 14),
      Text(
        'Stay where you are if it is safe. Your live location has been shared.',
        style: inter(11, weight: FontWeight.w500, height: 1.5, color: Colors.white),
      ),
      const SizedBox(height: 18),
      Container(
        color: DQ.dark,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ESTIMATED ARRIVAL',
              style: inter(7, weight: FontWeight.w500, spacing: 1.3, color: Colors.white),
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
          child: Text('UNDERSTOOD', style: inter(10, color: DQ.dark)),
        ),
      ),
    ],
  );
}

class _Option extends StatelessWidget {
  const _Option({required this.icon, required this.title, required this.sub, required this.dark, required this.onTap});

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
                    style: inter(7, weight: FontWeight.w500, spacing: 1, color: fg),
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
