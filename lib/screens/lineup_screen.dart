import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../data/festival_data.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';

/// Scherm 4: LINE-UP met dagen, stage-filter en favorieten.
class LineupScreen extends StatefulWidget {
  const LineupScreen({super.key, required this.go});

  final Go go;

  @override
  State<LineupScreen> createState() => _LineupScreenState();
}

class _LineupScreenState extends State<LineupScreen> {
  String _day = 'SAT 29';
  String _stage = 'ALL';
  final Set<String> _saved = {'SUB ZERO PROJECT', 'POWER HOUR'};

  @override
  Widget build(BuildContext context) {
    final acts = lineup.where((a) => _stage == 'ALL' || a.stage == _stage).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PageHeading(
                  kicker: 'CHOOSE YOUR BATTLES',
                  title: 'LINE-UP',
                  action: OutlineSquare(icon: LucideIcons.search),
                ),
                // Dagen
                Container(
                  decoration: BoxDecoration(border: Border.all(color: DQ.line2)),
                  child: Row(
                    children: [
                      for (final (i, day) in const ['FRI 28', 'SAT 29', 'SUN 30'].indexed)
                        Expanded(
                          child: Tap(
                            onTap: () => setState(() => _day = day),
                            child: Container(
                              height: 61,
                              decoration: BoxDecoration(
                                color: _day == day ? DQ.paper : DQ.dark,
                                border: i < 2 ? const Border(right: BorderSide(color: DQ.line2)) : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'JUNE',
                                    style: inter(
                                      7,
                                      weight: FontWeight.w500,
                                      spacing: 1,
                                      color: _day == day ? DQ.dark : DQ.muted,
                                    ),
                                  ),
                                  Text(day, style: bc(20, color: _day == day ? DQ.dark : DQ.muted)),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                // Stage-filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final stage in const ['ALL', 'RED', 'BLUE', 'BLACK', 'UV'])
                        Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: Tap(
                            onTap: () => setState(() => _stage = stage),
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 51),
                              height: 30,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _stage == stage ? DQ.red : Colors.transparent,
                                border: Border.all(color: _stage == stage ? DQ.red : DQ.line2),
                              ),
                              child: Text(
                                stage,
                                style: inter(9, weight: FontWeight.w800, color: _stage == stage ? DQ.dark : DQ.muted),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: DQ.line),
          for (final (i, act) in acts.indexed)
            _ActRow(
              act: act,
              number: i + 1,
              saved: _saved.contains(act.artist),
              onOpen: () => widget.go(DqPage.artist),
              onSave: () => setState(() {
                if (!_saved.remove(act.artist)) _saved.add(act.artist);
              }),
            ),
        ],
      ),
    );
  }
}

class _ActRow extends StatelessWidget {
  const _ActRow({
    required this.act,
    required this.number,
    required this.saved,
    required this.onOpen,
    required this.onSave,
  });

  final Act act;
  final int number;
  final bool saved;
  final VoidCallback onOpen;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final live = act.isLive;
    final bg = live ? const Color(0xFF211B0B) : DQ.dark;
    return Container(
      height: 76,
      decoration: BoxDecoration(
        border: live ? Border.all(color: DQ.yellow) : const Border(bottom: BorderSide(color: DQ.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 6, color: act.accent),
          Expanded(
            child: Tap(
              onTap: onOpen,
              child: Container(
                color: bg,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      right: 6,
                      bottom: -18,
                      child: Text(number.toString().padLeft(2, '0'), style: bc(58, color: const Color(0x08FFFFFF))),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 66,
                          padding: const EdgeInsets.only(left: 11),
                          decoration: const BoxDecoration(
                            border: Border(right: BorderSide(color: DQ.line)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(act.time, style: bc(18, color: Colors.white)),
                              Text(
                                act.end,
                                style: inter(8, weight: FontWeight.w500, color: const Color(0xFF666666)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  live ? 'LIVE NU · 10 MIN VERTRAAGD' : '${act.stage} STAGE',
                                  style: inter(
                                    8,
                                    weight: FontWeight.w800,
                                    spacing: 1,
                                    color: live ? DQ.yellow : DQ.muted,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(act.artist, style: bc(21, height: 0.95, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Tap(
            onTap: onSave,
            child: Container(
              width: 55,
              decoration: const BoxDecoration(
                color: Color(0xFF161616),
                border: Border(left: BorderSide(color: DQ.line)),
              ),
              child: DqIcon(saved ? 'Vol_hart' : 'Hart', size: 20, color: DQ.red),
            ),
          ),
        ],
      ),
    );
  }
}
