import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/dq_theme.dart';

/// Een klikbaar vlak. Als je erop drukt, wordt hij even iets lichter.
class Tap extends StatefulWidget {
  const Tap({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<Tap> createState() => _TapState();
}

class _TapState extends State<Tap> {
  bool _ingedrukt = false;

  void _zet(bool waarde) {
    if (widget.onTap != null) setState(() => _ingedrukt = waarde);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: widget.onTap,
    onTapDown: (_) => _zet(true),
    onTapUp: (_) => _zet(false),
    onTapCancel: () => _zet(false),
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 90),
      opacity: _ingedrukt ? 0.55 : 1,
      child: widget.child,
    ),
  );
}

/// Vierkante knop met dunne rand (zoeken, plus, bel, terug...).
class OutlineSquare extends StatelessWidget {
  const OutlineSquare({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 44,
    this.borderColor = const Color(0xFF4A4A4A),
    this.background = Colors.transparent,
    this.iconColor = DQ.paper,
    this.iconSize = 21,
  });

  final Object icon;
  final VoidCallback? onTap;
  final double size;
  final Color borderColor;
  final Color background;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Tap(
    onTap: onTap,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor),
      ),
      child: DqIcon(icon, size: iconSize, color: iconColor),
    ),
  );
}

/// Kop bovenaan een pagina: klein rood label + grote titel (+ optionele knop).
class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.kicker,
    required this.title,
    this.action,
    this.titleSize = 52,
  });

  final String kicker;
  final String title;
  final Widget? action;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width <= 390
        ? titleSize - 6
        : titleSize;
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 19),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kicker,
                  style: inter(
                    9,
                    color: DQ.red,
                    weight: FontWeight.w800,
                    spacing: 2,
                  ),
                ),
                const SizedBox(height: 7),
                Text(title, style: bc(size, height: 0.85, spacing: -2.2)),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

/// Sectietitel met rode balk links.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.kicker, required this.title});

  final String kicker;
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 12),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 5, color: DQ.red),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kicker,
                style: inter(
                  9,
                  color: DQ.red,
                  weight: FontWeight.w800,
                  spacing: 2,
                ),
              ),
              const SizedBox(height: 2),
              Text(title, style: bc(29, height: 0.95, spacing: -0.8)),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Grote cirkel-ring als decoratie (zie bijv. rechtsboven bij RED STAGE).
class Ring extends StatelessWidget {
  const Ring({
    super.key,
    required this.size,
    required this.width,
    required this.color,
  });

  final double size;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: width),
      ),
    ),
  );
}

/// Foto in zwart-wit met extra contrast (zoals in het ontwerp).
class GreyImage extends StatelessWidget {
  const GreyImage(this.asset, {super.key, this.contrast = 1.2});

  final String asset;
  final double contrast;

  @override
  Widget build(BuildContext context) {
    // Foto in kleur, zodat je alles goed ziet.
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

/// Geel-zwarte "waarschuwingsstrepen".
class HazardStripes extends StatelessWidget {
  const HazardStripes({super.key, this.width, this.height = 8});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(
      size: Size(width ?? double.infinity, height),
      painter: _HazardPainter(),
    ),
  );
}

class _HazardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = DQ.dark);
    final paint = Paint()..color = DQ.yellow;
    // Strepen van 12px breed onder 45 graden.
    const step = 24.0;
    final band = 12 * math.sqrt2;
    for (
      double x = -size.height;
      x < size.width + size.height;
      x += step * math.sqrt2
    ) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + band, 0)
        ..lineTo(x + band + size.height, size.height)
        ..lineTo(x + size.height, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Tekst met alleen een omlijning (zoals "FESTIVAL" op het startscherm).
class OutlineText extends StatelessWidget {
  const OutlineText(
    this.text, {
    super.key,
    required this.style,
    this.strokeWidth = 2,
    this.color = Colors.white,
  });

  final String text;
  final TextStyle style;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: style.copyWith(
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = color,
    ),
  );
}

/// Rechthoek met een stippellijn-rand.
class DashedBox extends StatelessWidget {
  const DashedBox({
    super.key,
    required this.child,
    this.color = const Color(0xFF555555),
    this.strokeWidth = 1,
    this.sides = const {
      AxisDirection.up,
      AxisDirection.down,
      AxisDirection.left,
      AxisDirection.right,
    },
  });

  final Widget child;
  final Color color;
  final double strokeWidth;
  final Set<AxisDirection> sides;

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: _DashPainter(color, strokeWidth, sides),
    child: child,
  );
}

class _DashPainter extends CustomPainter {
  _DashPainter(this.color, this.strokeWidth, this.sides);

  final Color color;
  final double strokeWidth;
  final Set<AxisDirection> sides;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    final dash = strokeWidth * 3, gap = strokeWidth * 3;
    void line(Offset a, Offset b) {
      final len = (b - a).distance;
      final dir = (b - a) / len;
      for (double d = 0; d < len; d += dash + gap) {
        canvas.drawLine(a + dir * d, a + dir * math.min(d + dash, len), p);
      }
    }

    final h = strokeWidth / 2;
    if (sides.contains(AxisDirection.up)) {
      line(Offset(0, h), Offset(size.width, h));
    }
    if (sides.contains(AxisDirection.down)) {
      line(Offset(0, size.height - h), Offset(size.width, size.height - h));
    }
    if (sides.contains(AxisDirection.left)) {
      line(Offset(h, 0), Offset(h, size.height));
    }
    if (sides.contains(AxisDirection.right)) {
      line(Offset(size.width - h, 0), Offset(size.width - h, size.height));
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter old) => old.color != color;
}

/// Hellende vorm (zoals het paarse "SZP"-blok).
Matrix4 skew(double degrees) => Matrix4.skewX(degrees * math.pi / 180);

/// Eigen pictogram uit assets/pictograms/. De zwarte PNG krijgt de kleur die je meegeeft.
class Picto extends StatelessWidget {
  const Picto(
    this.name, {
    super.key,
    this.size = 24,
    this.color = Colors.white,
  });

  final String name;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Center(
    widthFactor: 1,
    heightFactor: 1,
    child: Image.asset(
      'assets/pictograms/$name.png',
      width: size * 1.2,
      height: size * 1.2,
      color: color,
    ),
  );
}

/// Laat een eigen pictogram zien (als je een naam geeft, bijv. 'Kaart')
/// of een standaard-icoon (als je LucideIcons.xxx geeft).
class DqIcon extends StatelessWidget {
  const DqIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color = Colors.white,
  });

  final Object icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    if (icon is String) return Picto(icon, size: size, color: color);
    return Icon(icon as IconData, size: size * 1.2, color: color);
  }
}

/// Aan/uit-schakelaar in DEFQON-stijl (hoekig, lime als hij aan staat).
class Schakelaar extends StatelessWidget {
  const Schakelaar({super.key, required this.aan, required this.onChanged});

  final bool aan;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Tap(
    onTap: () => onChanged(!aan),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 50,
      height: 28,
      padding: const EdgeInsets.all(3),
      alignment: aan ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: aan ? DQ.lime : const Color(0xFF222222),
        border: Border.all(color: aan ? DQ.lime : DQ.line2),
      ),
      child: Container(width: 20, height: 20, color: aan ? DQ.dark : DQ.muted),
    ),
  );
}
