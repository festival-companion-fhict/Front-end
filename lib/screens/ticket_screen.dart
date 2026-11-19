import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../theme/dq_theme.dart';
import '../widgets/chrome.dart';
import '../widgets/common.dart';

/// Scherm 11: WEEKEND PASS – je ticket met QR-code.
class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key, required this.go, required this.openProfile});

  final Go go;
  final VoidCallback openProfile;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.35, -1),
          end: Alignment(0.35, 1),
          colors: [Color(0xFF171717), Color(0xFF080808)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: DQ.line)),
              ),
              child: Row(
                children: [
                  OutlineSquare(
                    icon: LucideIcons.arrowLeft,
                    borderColor: const Color(0x70FFFFFF),
                    background: const Color(0x990B0B0B),
                    iconColor: Colors.white,
                    onTap: () => go(DqPage.home),
                  ),
                  Expanded(
                    child: Center(child: Text('WEEKEND PASS', style: bc(18, spacing: 1))),
                  ),
                  ProfileButton(onTap: openProfile),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 27, 24, 18),
                      child: Center(child: _Poster()),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF3A3A3A))),
                      child: Column(
                        children: [
                          const IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(child: _Detail('VALID', Text('27—30 JUNE'), rightBorder: true)),
                                Expanded(child: _Detail('ENTRANCE', Text('NORTH GATE'))),
                              ],
                            ),
                          ),
                          Container(height: 1, color: const Color(0xFF3A3A3A)),
                          _Detail(
                            'STATUS',
                            Row(
                              children: [
                                const Icon(LucideIcons.check, size: 14, color: DQ.lime),
                                const SizedBox(width: 5),
                                Text('ACTIVE', style: bc(16, color: DQ.lime)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.info, size: 17, color: DQ.muted),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              'Turn up your screen brightness and keep the QR fully visible.',
                              style: inter(9, weight: FontWeight.w500, height: 1.4, color: DQ.muted),
                            ),
                          ),
                        ],
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

class _Poster extends StatelessWidget {
  const _Poster();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: DQ.red, offset: Offset(10, 12))],
      ),
      child: ClipRect(
        child: Container(
          color: DQ.lime,
          child: Stack(
            children: [
              const Positioned(right: -85, top: 58, child: Ring(size: 160, width: 30, color: Color(0x1F111111))),
              const Positioned(left: -12, top: 253, child: _Cut()),
              const Positioned(right: -12, top: 253, child: _Cut()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 16, 17, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Brand(color: DQ.dark, showSub: true, center: false)),
                            Text('2025', style: bc(14, color: DQ.dark)),
                          ],
                        ),
                        const SizedBox(height: 35),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            color: DQ.dark,
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            child: Text('4-DAY', style: inter(8, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          'WEEKEND\nWARRIOR',
                          style: bc(48, italic: true, height: 0.85, spacing: -2, color: DQ.dark),
                        ),
                        const SizedBox(height: 22),
                        const Center(child: _QrCode()),
                        const SizedBox(height: 22),
                        DashedBox(
                          color: DQ.dark,
                          strokeWidth: 2,
                          sides: const {AxisDirection.up},
                          child: Padding(
                            padding: const EdgeInsets.only(top: 18, bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WARRIOR',
                                  style: inter(7, weight: FontWeight.w800, spacing: 1, color: DQ.dark),
                                ),
                                Text('NANCO HABRAKEN', style: bc(23, color: DQ.dark)),
                                const Text(
                                  '#D1-029194-84',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: DQ.dark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: DQ.dark,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'SCAN AT ENTRANCE · SCAN AT ENTRANCE · SCAN AT ENTRANCE ·',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.clip,
                      style: bc(10, spacing: 1, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Het "afscheurgaatje" aan de zijkant van het ticket.
class _Cut extends StatelessWidget {
  const _Cut();

  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: 24,
    decoration: const BoxDecoration(color: DQ.dark, shape: BoxShape.circle),
  );
}

class _QrCode extends StatelessWidget {
  const _QrCode();

  @override
  Widget build(BuildContext context) => Container(
    width: 180,
    height: 180,
    color: Colors.white,
    padding: const EdgeInsets.all(10),
    child: GridView.count(
      crossAxisCount: 9,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        for (var i = 0; i < 81; i++) ColoredBox(color: (i * 7 + (i ~/ 9) * 3) % 5 < 2 ? DQ.dark : Colors.white),
      ],
    ),
  );
}

class _Detail extends StatelessWidget {
  const _Detail(this.label, this.value, {this.rightBorder = false});

  final String label;
  final Widget value;
  final bool rightBorder;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      border: rightBorder ? const Border(right: BorderSide(color: Color(0xFF3A3A3A))) : null,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: inter(7, weight: FontWeight.w500, spacing: 1, color: DQ.muted),
        ),
        const SizedBox(height: 3),
        DefaultTextStyle.merge(style: bc(16), child: value),
      ],
    ),
  );
}
