import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../data/festival_data.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';
import 'map_screen.dart';

/// Scherm 9: MY SQUAD – je vrienden op het terrein.
class CrewScreen extends StatelessWidget {
  const CrewScreen({super.key, required this.go});

  final Go go;

  static const crewCode = 'R3D-029';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeading(
            kicker: 'NEVER RAVE ALONE',
            title: 'MY SQUAD',
            action: OutlineSquare(
              icon: LucideIcons.plus,
              onTap: () => _vriendToevoegen(context),
            ),
          ),
          // Squad-code
          Container(
            height: 80,
            color: DQ.lime,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                const Positioned(
                  right: 65,
                  top: -40,
                  child: Ring(size: 90, width: 18, color: Color(0x1F111111)),
                ),
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
                              'SQUAD CODE',
                              style: inter(
                                7,
                                weight: FontWeight.w800,
                                spacing: 1.3,
                                color: DQ.dark,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              crewCode,
                              style: bc(
                                28,
                                spacing: 2,
                                color: DQ.dark,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(13),
                      child: Tap(
                        onTap: () {
                          Clipboard.setData(
                            const ClipboardData(text: crewCode),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: DQ.dark,
                              content: Text(
                                'Squad-code gekopieerd!',
                                style: inter(11, color: Colors.white),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          color: DQ.dark,
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                          alignment: Alignment.center,
                          child: Text(
                            'SHARE',
                            style: inter(9, color: Colors.white),
                          ),
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
                  child: const DqIcon(
                    'Duo_kaart',
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NEXT MEET-UP',
                        style: inter(7, spacing: 1.2, color: DQ.red),
                      ),
                      const SizedBox(height: 2),
                      Text('18:45 · RED STAGE', style: bc(20)),
                      const SizedBox(height: 2),
                      Text(
                        'POWER HOUR · 4 WARRIORS GOING',
                        style: inter(
                          8,
                          weight: FontWeight.w800,
                          color: DQ.muted,
                        ),
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
            Tap(
              onTap: () => _toonProfiel(context, m),
              child: Container(
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
                      child: Text(
                        m.initials,
                        style: inter(
                          10,
                          color: m.darkText ? DQ.dark : Colors.white,
                        ),
                      ),
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
                              const DqIcon(
                                'Duo_kaart',
                                size: 11,
                                color: DQ.muted,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                m.location,
                                style: inter(
                                  8,
                                  weight: FontWeight.w800,
                                  color: DQ.muted,
                                ),
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
                    const DqIcon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: Color(0xFF777777),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// + knop: vriend toevoegen met zijn/haar squad-code.
  void _vriendToevoegen(BuildContext context) {
    final code = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DQ.dark,
      shape: const RoundedRectangleBorder(),
      isScrollControlled: true, // zodat het toetsenbord er niet overheen valt
      builder: (sheet) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheet).bottom),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 6, color: DQ.lime),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'NIEUWE WARRIOR',
                      style: inter(9, color: DQ.lime, spacing: 2),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'VRIEND TOEVOEGEN',
                      style: bc(40, height: 0.9, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vraag je vriend om zijn of haar squad-code (staat in MY SQUAD) en typ hem hieronder.',
                      style: inter(
                        11,
                        weight: FontWeight.w500,
                        height: 1.5,
                        color: const Color(0xFFAAAAAA),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: code,
                      autofocus: true,
                      textCapitalization: TextCapitalization.characters,
                      style: bc(26, color: Colors.white, spacing: 2),
                      cursorColor: DQ.lime,
                      decoration: InputDecoration(
                        hintText: 'BIJV. B7U-114',
                        hintStyle: bc(
                          26,
                          color: const Color(0xFF444444),
                          spacing: 2,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF151515),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: DQ.line2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: DQ.lime),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Tap(
                      onTap: () {
                        final tekst = code.text.trim().toUpperCase();
                        if (tekst.isEmpty) return; // eerst een code typen
                        Navigator.of(sheet).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: DQ.dark,
                            content: Text(
                              'Uitnodiging verstuurd naar $tekst',
                              style: inter(11, color: Colors.white),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 52,
                        color: DQ.lime,
                        alignment: Alignment.center,
                        child: Text(
                          'TOEVOEGEN',
                          style: inter(10, color: DQ.dark),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tik op een vriend: mini-profiel met PING en TOON OP KAART.
  void _toonProfiel(BuildContext context, CrewMember m) {
    final verborgen = m.kaartPlek == '';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DQ.dark,
      shape: const RoundedRectangleBorder(),
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 6, color: m.color),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        color: m.color,
                        alignment: Alignment.center,
                        child: Text(
                          m.initials,
                          style: bc(
                            26,
                            color: m.darkText ? DQ.dark : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WARRIOR',
                              style: inter(
                                8,
                                color: m.color == Colors.white
                                    ? DQ.muted
                                    : m.color,
                                spacing: 1.5,
                              ),
                            ),
                            Text(
                              m.name,
                              style: bc(36, height: 1, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: DQ.line)),
                    ),
                    child: Row(
                      children: [
                        const DqIcon('Duo_kaart', size: 16, color: DQ.muted),
                        const SizedBox(width: 10),
                        Text(
                          'LOCATIE',
                          style: inter(8, spacing: 1, color: DQ.muted),
                        ),
                        const Spacer(),
                        Text(
                          verborgen ? 'VERBORGEN' : m.location,
                          style: bc(16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: DQ.line)),
                    ),
                    child: Row(
                      children: [
                        const DqIcon('Info', size: 16, color: DQ.muted),
                        const SizedBox(width: 10),
                        Text(
                          'LAATST GEZIEN',
                          style: inter(8, spacing: 1, color: DQ.muted),
                        ),
                        const Spacer(),
                        Text(
                          verborgen ? '—' : 'NU',
                          style: bc(16, color: DQ.lime),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Tap(
                          onTap: () {
                            Navigator.of(sheet).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: DQ.dark,
                                content: Text(
                                  'Ping verstuurd naar ${m.name}!',
                                  style: inter(11, color: Colors.white),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 52,
                            color: DQ.paper,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const DqIcon(
                                  LucideIcons.bellRing,
                                  size: 16,
                                  color: DQ.dark,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'STUUR PING',
                                  style: inter(9, color: DQ.dark),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Tap(
                          onTap: verborgen
                              ? null
                              : () {
                                  Navigator.of(sheet).pop();
                                  kaartStartSelectie = m.kaartPlek;
                                  go(DqPage.map);
                                },
                          child: Container(
                            height: 52,
                            color: verborgen ? const Color(0xFF222222) : DQ.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DqIcon(
                                  'Kaart',
                                  size: 16,
                                  color: verborgen ? DQ.muted : Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'TOON OP KAART',
                                  style: inter(
                                    9,
                                    color: verborgen ? DQ.muted : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
