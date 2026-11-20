import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';

double _deg(double d) => d * math.pi / 180;

/// Scherm 3: GROUND MAP – plattegrond van het terrein.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.go});

  final Go go;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _filter = 'STAGES';
  final String _selected = 'RED STAGE';

  

  static const _filters = [
    ('STAGES', LucideIcons.zap),
    ('FOOD', LucideIcons.utensils),
    ('WATER', LucideIcons.droplets),
    ('WC', LucideIcons.toilet),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeading(
            kicker: 'YOU ARE HERE',
            title: 'GROUND MAP',
            titleSize: 43,
            action: OutlineSquare(icon: LucideIcons.search),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final (name, icon) in _filters)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Tap(
                      onTap: () => setState(() => _filter = name),
                      child: Container(
                        height: 34,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: _filter == name ? DQ.paper : const Color(0xFF121212),
                          border: Border.all(color: _filter == name ? DQ.paper : DQ.line2),
                        ),
                        child: Row(
                          children: [
                            Icon(icon, size: 14, color: _filter == name ? DQ.dark : DQ.muted),
                            const SizedBox(width: 5),
                            Text(
                              name,
                              style: inter(8, weight: FontWeight.w800, color: _filter == name ? DQ.dark : DQ.muted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
              ClipRect(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.asset('assets/images/Festival kaart naam.png'),
            ),
          ),
          _MapSheet(selected: _selected, onGo: () => widget.go(DqPage.lineup)),
        ],
      ),
    );
  }
}

class _FestivalMap extends StatelessWidget {
  const _FestivalMap({required this.filter, required this.selected, required this.onSelect});

  final String filter;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 475,
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        border: Border.all(color: DQ.line),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          // Hoe meer een filter actief is, hoe feller die iconen.
          double fade(String f) => filter == f || filter == 'STAGES' ? 1 : 0.35;

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              const Positioned.fill(child: CustomPaint(painter: _GridPainter())),
              Positioned(
                left: 8,
                top: 8,
                child: Text(
                  '52°26\'18"N\n5°45\'58"E',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    height: 1.4,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const _Road(left: -100, top: 205, width: 560, angle: -25),
              const _Road(left: 10, top: 160, width: 460, angle: 64),
              const _Road(left: -20, top: 475 - 70 - 10, width: 290, angle: 13),
              Positioned(
                right: -80,
                top: 40,
                child: Transform.rotate(
                  angle: _deg(12),
                  child: const CustomPaint(size: Size(170, 370), painter: _LakePainter()),
                ),
              ),
              Positioned(left: 20, top: 70, child: _Zone('CAMPSITE', 23)),
              Positioned(right: 25, bottom: 50, child: _Zone('WASTELANDS', 18)),
              Positioned(
                left: w * 0.42,
                top: 80,
                child: _StageMarker('RED', DQ.red, selected == 'RED STAGE', () => onSelect('RED STAGE')),
              ),
              Positioned(
                left: w * 0.18,
                bottom: 83,
                child: _StageMarker('BLUE', DQ.blue, selected == 'BLUE STAGE', () => onSelect('BLUE STAGE')),
              ),
              Positioned(
                right: w * 0.13,
                top: 230,
                child: _StageMarker(
                  'BLACK',
                  const Color(0xFFEEEEEE),
                  selected == 'BLACK STAGE',
                  () => onSelect('BLACK STAGE'),
                ),
              ),
              Positioned(right: w * 0.25, top: 118, child: _Service(DQ.cyan, LucideIcons.droplets, fade('WATER'))),
              Positioned(left: w * 0.23, top: 208, child: _Service(DQ.yellow, LucideIcons.utensils, fade('FOOD'))),
              Positioned(right: w * 0.33, bottom: 72, child: _Service(DQ.lime, LucideIcons.toilet, fade('WC'))),
              Positioned(left: w * 0.54, top: 220, child: const _CrewDot('MA', DQ.lime)),
              Positioned(left: w * 0.27, top: 140, child: const _CrewDot('EM', DQ.cyan)),
              Positioned(
                left: w * 0.47,
                bottom: 77,
                child: Container(
                  width: 39,
                  height: 39,
                  decoration: const BoxDecoration(color: Color(0x33FF2134), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: DQ.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ),
              // Donkere rand (vignet)
              const Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-0.06, 0.18),
                        radius: 1.1,
                        colors: [Colors.transparent, Colors.transparent, Color(0x55000000)],
                        stops: [0, 0.35, 0.75],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  width: 42,
                  height: 42,
                  color: DQ.paper,
                  child: const Icon(LucideIcons.locateFixed, color: DQ.dark),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0x09FFFFFF);
    for (double x = 0; x < size.width; x += 22) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 1, size.height), p);
    }
    for (double y = 0; y < size.height; y += 22) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LakePainter extends CustomPainter {
  const _LakePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawOval(rect, Paint()..color = const Color(0xFF172426));
    canvas.drawArc(
      rect.deflate(1.5),
      math.pi * 0.62,
      math.pi * 0.76,
      false,
      Paint()
        ..color = DQ.cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Road extends StatelessWidget {
  const _Road({required this.left, required this.top, required this.width, required this.angle});

  final double left;
  final double top;
  final double width;
  final double angle;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    child: Transform.rotate(
      angle: _deg(angle),
      child: Container(
        width: width,
        height: 10,
        decoration: BoxDecoration(
          color: const Color(0xFF272727),
          border: Border.all(color: const Color(0xFF555555)),
        ),
      ),
    ),
  );
}

class _Zone extends StatelessWidget {
  const _Zone(this.label, this.size);

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: _deg(-12),
    child: Text(label, style: bc(size, spacing: 2, color: const Color(0xFF494949))),
  );
}

class _StageMarker extends StatelessWidget {
  const _StageMarker(this.label, this.color, this.selected, this.onTap);

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tap(
    onTap: onTap,
    child: Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.white, width: selected ? 3 : 2),
            boxShadow: selected ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 18)] : null,
          ),
        ),
        Container(
          color: DQ.ink,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          child: Text(label, style: bc(11, color: Colors.white)),
        ),
      ],
    ),
  );
}

class _Service extends StatelessWidget {
  const _Service(this.color, this.icon, this.opacity);

  final Color color;
  final IconData icon;
  final double opacity;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    duration: const Duration(milliseconds: 200),
    opacity: opacity,
    child: Container(
      width: 31,
      height: 31,
      color: color,
      child: Icon(icon, size: 16, color: DQ.dark),
    ),
  );
}

class _CrewDot extends StatelessWidget {
  const _CrewDot(this.initials, this.color);

  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 29,
    height: 29,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: Text(initials, style: inter(8, color: DQ.dark)),
  );
}

class _MapSheet extends StatelessWidget {
  const _MapSheet({required this.selected, required this.onGo});

  final String selected;
  final VoidCallback onGo;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 105),
    color: DQ.paper,
    padding: const EdgeInsets.all(12),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 7, color: DQ.red),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DESTINATION 01',
                  style: inter(7, weight: FontWeight.w800, spacing: 1.2, color: DQ.muted),
                ),
                const SizedBox(height: 2),
                Text(selected, style: bc(25, color: DQ.dark)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(LucideIcons.zap, size: 13, color: DQ.red),
                    const SizedBox(width: 3),
                    Text(
                      'BUSY · 8 MIN WALK',
                      style: inter(8, weight: FontWeight.w800, color: DQ.dark),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Center(
            child: Tap(
              onTap: onGo,
              child: Container(
                width: 58,
                height: 58,
                color: DQ.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.navigation, size: 20, color: Colors.white),
                    const SizedBox(height: 2),
                    Text('GO', style: inter(9, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
