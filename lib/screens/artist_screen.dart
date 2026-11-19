import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';

/// Scherm 5: artiestpagina (SUB ZERO PROJECT).
class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key, required this.go});

  final Go go;

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  bool _favorite = true;
  bool _reminder = true;
  String _tab = 'ABOUT';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final nameSize = width <= 390 ? 56.0 : (width * 0.18).clamp(59.0, 84.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 520,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              children: [
                const ColoredBox(color: DQ.dark),
                const GreyImage('assets/images/defqon-fire.jpg', contrast: 1.3),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0x55FF2134), Colors.transparent], stops: [0, 0.7]),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x22000000), DQ.ink],
                      stops: [0.25, 0.98],
                    ),
                  ),
                ),
                Positioned(
                  right: -15,
                  top: 40,
                  child: OutlineText('04', style: bc(180), color: const Color(0x28FFFFFF)),
                ),
                Positioned(
                  left: 15,
                  top: 16,
                  child: OutlineSquare(
                    icon: LucideIcons.arrowLeft,
                    borderColor: const Color(0x70FFFFFF),
                    background: const Color(0x990B0B0B),
                    iconColor: Colors.white,
                    iconSize: 22,
                    onTap: () => widget.go(DqPage.lineup),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 16,
                  child: Tap(
                    onTap: () => setState(() => _favorite = !_favorite),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0x990B0B0B),
                        border: Border.all(color: const Color(0x70FFFFFF)),
                      ),
                      child: Icon(_favorite ? Icons.favorite : LucideIcons.heart, color: DQ.red, size: 22),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  right: 15,
                  bottom: 26,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIVE ACT',
                        style: inter(9, color: DQ.lime, weight: FontWeight.w800, spacing: 2),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'SUB ZERO\nPROJECT',
                        style: bc(
                          nameSize,
                          italic: true,
                          height: 0.82,
                          spacing: -3.5,
                          shadows: const [Shadow(offset: Offset(4, 4))],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Schuin lint met genres
          Transform.rotate(
            angle: -1 * 3.14159 / 180,
            child: Container(
              height: 34,
              color: DQ.lime,
              alignment: Alignment.centerLeft,
              child: Text(
                'PSYCHODELIC · HARDSTYLE · PSYCHODELIC · HARDSTYLE · PSYCHODELIC · HARDSTYLE ·',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.clip,
                style: bc(15, color: DQ.dark, spacing: 1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 22, 15, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(color: Color(0xFF393939))),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Expanded(child: _MetaCell('WHEN', 'SAT · 16:00')),
                        const Expanded(child: _MetaCell('WHERE', 'RED STAGE')),
                        Tap(
                          onTap: () => widget.go(DqPage.map),
                          child: Container(
                            color: DQ.red,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(LucideIcons.navigation, size: 18, color: Colors.white),
                                const SizedBox(height: 3),
                                Text('ROUTE', style: inter(9, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    for (final tab in const ['ABOUT', 'MEDIA', 'SETS'])
                      Padding(
                        padding: const EdgeInsets.only(right: 22),
                        child: Tap(
                          onTap: () => setState(() => _tab = tab),
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: _tab == tab ? DQ.red : Colors.transparent, width: 2),
                              ),
                            ),
                            child: Text(
                              tab,
                              style: bc(14, color: _tab == tab ? Colors.white : const Color(0xFF555555)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(switch (_tab) {
                  'ABOUT' =>
                    'Two minds. One brutal vision. Sub Zero Project tears through the boundaries of '
                        'hardstyle with cinematic drops and relentless energy.',
                  'MEDIA' => 'Foto\'s en video\'s van deze act komen hier.',
                  _ => 'Eerdere sets en tracklists komen hier.',
                }, style: inter(12, weight: FontWeight.w500, color: const Color(0xFFAAAAAA), height: 1.6)),
                const SizedBox(height: 20),
                Tap(
                  onTap: () => setState(() => _reminder = !_reminder),
                  child: Container(
                    height: 52,
                    color: _reminder ? DQ.lime : const Color(0xFF1A1A1A),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Icon(LucideIcons.bell, color: _reminder ? DQ.dark : Colors.white),
                        const SizedBox(width: 10),
                        Text('REMIND ME 15 MIN BEFORE', style: inter(10, color: _reminder ? DQ.dark : Colors.white)),
                        const Spacer(),
                        if (_reminder) const Icon(LucideIcons.check, color: DQ.dark),
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

class _MetaCell extends StatelessWidget {
  const _MetaCell(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 14),
    decoration: const BoxDecoration(
      border: Border(right: BorderSide(color: Color(0xFF393939))),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: inter(7, weight: FontWeight.w500, spacing: 1.2, color: DQ.muted),
        ),
        const SizedBox(height: 4),
        Text(value, style: bc(17)),
      ],
    ),
  );
}
