import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../data/festival_data.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';

/// Scherm 8: LIVE NIEUWS.
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key, required this.go});

  final Go go;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeading(
            kicker: 'LAATST BIJGEWERKT · NU',
            title: 'LIVE NIEUWS',
            action: OutlineSquare(icon: LucideIcons.bell),
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
                  child: Text('!', style: bc(180, color: const Color(0x11000000))),
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
                          Text('BELANGRIJK · 18:47', style: inter(7, spacing: 1.2, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Text('EXTRA WATERPUNTEN OPEN', style: bc(29, height: 0.95, color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 340),
                        child: Text(
                          'Door de warmte zijn extra tappunten geopend naast RED en BLUE. Drink voldoende.',
                          style: inter(10, weight: FontWeight.w500, height: 1.5, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Tap(
                        onTap: () => go(DqPage.map),
                        child: Container(
                          color: DQ.dark,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('TOON OP KAART', style: inter(8, color: Colors.white)),
                              const SizedBox(width: 24),
                              const DqIcon('Pijl_rechts', color: Colors.white),
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
                    boxShadow: [BoxShadow(color: Color(0x18BDFC16), spreadRadius: 6)],
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIVE · RED STAGE',
                        style: inter(7, weight: FontWeight.w500, spacing: 1, color: DQ.lime),
                      ),
                      const SizedBox(height: 3),
                      Text('POWER HOUR IS 10 MIN VERTRAAGD', style: bc(15)),
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
          Container(height: 1, color: const Color(0xFF383838)),
          for (final item in news)
            Container(
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
                        Text(item.category, style: inter(7, spacing: 1, color: DQ.muted)),
                        const SizedBox(height: 3),
                        Text(item.title, style: bc(19)),
                        const SizedBox(height: 3),
                        Text(
                          item.text,
                          style: inter(9, weight: FontWeight.w500, height: 1.4, color: DQ.muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: DqIcon(LucideIcons.chevronRight, size: 16, color: Color(0xFF555555)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
