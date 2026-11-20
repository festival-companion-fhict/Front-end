import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/festival_data.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';

/// Scherm 9: MY CREW – je vrienden op het terrein.
class CrewScreen extends StatelessWidget {
  const CrewScreen({super.key});

  static const crewCode = 'R3D-029';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeading(
            kicker: 'NEVER RAVE ALONE',
            title: 'MY CREW',
            action: OutlineSquare(icon: LucideIcons.plus),
          ),
          // Crew-code
          Container(
            height: 80,
            color: DQ.lime,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                const Positioned(right: 65, top: -40, child: Ring(size: 90, width: 18, color: Color(0x1F111111))),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CREW CODE',
                              style: inter(7, weight: FontWeight.w800, spacing: 1.3, color: DQ.dark),
                            ),
                            const Spacer(),
                            Text(crewCode, style: bc(28, spacing: 2, color: DQ.dark, height: 1)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(13),
                      child: Tap(
                        onTap: () {
                          Clipboard.setData(const ClipboardData(text: crewCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: DQ.dark,
                              content: Text('Crew code gekopieerd!', style: inter(11, color: Colors.white)),
                            ),
                          );
                        },
                        child: Container(
                          color: DQ.dark,
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                          alignment: Alignment.center,
                          child: Text('SHARE', style: inter(9, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Volgende meet-up
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(border: Border.all(color: DQ.line)),
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  color: DQ.red,
                  child: const DqIcon('Duo_kaart', size: 20, color: Colors.white),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NEXT MEET-UP', style: inter(7, spacing: 1.2, color: DQ.red)),
                      const SizedBox(height: 2),
                      Text('18:45 · RED STAGE', style: bc(20)),
                      const SizedBox(height: 2),
                      Text(
                        'POWER HOUR · 4 WARRIORS GOING',
                        style: inter(8, weight: FontWeight.w800, color: DQ.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SectionTitle(kicker: 'LIVE LOCATIONS', title: 'WARRIORS'),
          Container(height: 1, color: DQ.line),
          for (final m in crew)
            Container(
              constraints: const BoxConstraints(minHeight: 68),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: DQ.line)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    color: m.color,
                    alignment: Alignment.center,
                    child: Text(m.initials, style: inter(10, color: m.darkText ? DQ.dark : Colors.white)),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: bc(18)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const DqIcon('Duo_kaart', size: 11, color: DQ.muted),
                            const SizedBox(width: 3),
                            Text(
                              m.location,
                              style: inter(8, weight: FontWeight.w800, color: DQ.muted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'NOW',
                    style: inter(7, weight: FontWeight.w800, color: DQ.lime),
                  ),
                  const SizedBox(width: 11),
                  const DqIcon(LucideIcons.chevronRight, size: 16, color: Color(0xFF555555)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
