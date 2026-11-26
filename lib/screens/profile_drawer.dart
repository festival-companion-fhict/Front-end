import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';

/// Scherm 10: profielmenu dat van rechts inschuift.
class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key, required this.close, required this.go});

  final VoidCallback close;
  final Go go;

  static const _settings = [
    'Taal · Nederlands',
    'Meldingen · Aan',
    'Locatie delen · Crew',
    'Offline festivaldata',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final pad = MediaQuery.paddingOf(context);
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: Tap(
              onTap: close,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: const ColoredBox(color: Color(0xBB000000)),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: (width * 0.88).clamp(0, 390),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: 0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              builder: (_, t, child) => FractionalTranslation(
                translation: Offset(t, 0),
                child: child,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: DQ.dark,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 70,
                      offset: Offset(-25, 0),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20, 74 + pad.top, 20, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 77,
                              height: 77,
                              color: DQ.lime,
                              alignment: Alignment.center,
                              child: Text('NH', style: bc(25, color: DQ.dark)),
                            ),
                          ),
                          const SizedBox(height: 17),
                          Text(
                            'WEEKEND WARRIOR',
                            style: inter(8, spacing: 1.5, color: DQ.red),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'NANCO\nHABRAKEN',
                            style: bc(42, italic: true, height: 0.85),
                          ),
                          const SizedBox(height: 24),
                          Tap(
                            onTap: () {
                              go(DqPage.ticket);
                              close();
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 65),
                              color: DQ.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  const DqIcon(
                                    LucideIcons.qrCode,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TOEGANG',
                                          style: inter(
                                            7,
                                            weight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'OPEN MIJN TICKET',
                                          style: bc(18, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const DqIcon(
                                    'Pijl_rechts',
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(height: 1, color: const Color(0xFF3A3A3A)),
                          for (final s in _settings)
                            Container(
                              height: 55,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFF3A3A3A)),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      s,
                                      style: inter(
                                        10,
                                        weight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const DqIcon(
                                    LucideIcons.chevronRight,
                                    size: 16,
                                    color: Color(0xFF666666),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 17,
                      top: 18 + pad.top,
                      child: OutlineSquare(
                        icon: LucideIcons.x,
                        size: 42,
                        borderColor: DQ.line2,
                        iconColor: Colors.white,
                        onTap: close,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
