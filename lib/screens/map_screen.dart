import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';
import '../widgets/festival_kaart.dart';

double _deg(double d) => d * math.pi / 180;

/// Scherm 3: GROUND MAP – plattegrond van het terrein.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.go});

  final Go go;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

/// Eén regel in de zoekresultaten: een stage of een punt (eten, wc, ...).
class _Resultaat {
  const _Resultaat({
    required this.titel,
    required this.soort,
    required this.kleur,
    required this.picto,
    required this.plek,
    required this.lopen,
    this.stage,
    this.punt,
  });

  final String titel;
  final String soort;
  final Color kleur;
  final String picto;
  final Offset plek;
  final String lopen;
  final KaartStage? stage;
  final KaartPunt? punt;
}

class _MapScreenState extends State<MapScreen> {
  String _filter = ''; // '' = alles laten zien
  String _selected = 'RED STAGE';
  bool _paneelOpen = false; // is het uitklap-paneel open?
  final _zoekTekst = TextEditingController(); // wat er in de zoekbalk staat

  // De categorieën in het uitklap-paneel: (naam op de knop, soort, pictogram)
  static const _categorieen = [
    ('STAGES', 'STAGES', 'Stages'),
    ('ETEN', 'ETEN', 'Eten'),
    ('DRINKEN', 'DRINKEN', 'Drinken'),
    ('WATER', 'WATER', 'Waterpunt'),
    ('WC', 'WC', 'Wc'),
    ('EHBO', 'EHBO', 'EHBO'),
    ('DRUKTE', 'DRUKTE', 'Menigde'),
  ];

  // Beginzoom van de kaart (2 = twee keer ingezoomd).
  static Matrix4 _beginZoom() =>
      Matrix4.diagonal3Values(2.0, 2.0, 1.0)
        ..setTranslationRaw(-300.0, -150.0, 0.0);
  final _kaartZoom = TransformationController(_beginZoom());

  @override
  void dispose() {
    _kaartZoom.dispose();
    _zoekTekst.dispose();
    super.dispose();
  }

  /// Alle stages en punten als één lijst, zodat je erin kunt zoeken.
  List<_Resultaat> get _alles => [
    for (final s in kaartStages)
      _Resultaat(
        titel: s.naam,
        soort: 'STAGES',
        kleur: s.kleur,
        picto: 'Stages',
        plek: s.vak.center,
        lopen: s.lopen,
        stage: s,
      ),
    for (final p in kaartPunten)
      _Resultaat(
        titel: p.titel,
        soort: p.soort,
        kleur: puntStijl[p.soort]!.$1,
        picto: puntStijl[p.soort]!.$2,
        plek: p.plek,
        lopen: p.lopen,
        punt: p,
      ),
  ];

  /// Wat er in de lijst komt: passend bij de zoektekst én de gekozen categorie.
  List<_Resultaat> get _resultaten {
    final zoek = _zoekTekst.text.trim().toUpperCase();
    return _alles.where((r) {
      final pastBijFilter =
          _filter == '' || _filter == 'DRUKTE' || r.soort == _filter;
      final pastBijZoek =
          zoek.isEmpty ||
          r.titel.toUpperCase().contains(zoek) ||
          r.soort.contains(zoek);
      return pastBijFilter && pastBijZoek;
    }).toList();
  }

  /// Zoom de kaart naar een plek en open het info-scherm.
  void _gaNaar(_Resultaat r) {
    FocusScope.of(context).unfocus();
    final kaartBreedte = MediaQuery.sizeOf(context).width - 28;
    final kaartHoogte = kaartBreedte * 1176 / 1337;
    const schaal = 2.6;
    final x = r.plek.dx * kaartBreedte / 1337;
    final y = r.plek.dy * kaartHoogte / 1176;
    final tx = (kaartBreedte / 2 - x * schaal).clamp(
      kaartBreedte - kaartBreedte * schaal,
      0.0,
    );
    final ty = (kaartHoogte / 2 - y * schaal).clamp(
      kaartHoogte - kaartHoogte * schaal,
      0.0,
    );
    setState(() {
      _paneelOpen = false;
      _selected = r.titel;
      _kaartZoom.value = Matrix4.diagonal3Values(schaal, schaal, 1.0)
        ..setTranslationRaw(tx, ty, 0.0);
    });
    if (r.stage != null) toonStageInfo(context, r.stage!);
    if (r.punt != null) toonPuntInfo(context, r.punt!);
  }

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
          ),
          _zoekBalk(),
          if (_paneelOpen) _paneel(),
          const SizedBox(height: 10),
          ClipRect(
            child: InteractiveViewer(
              transformationController: _kaartZoom,
              minScale: 1,
              maxScale: 4,
              child: FestivalKaart(
                filter: _filter,
                selected: _selected,
                onSelect: (stage) => setState(() => _selected = stage),
              ),
            ),
          ),
          _MapSheet(selected: _selected, onGo: () => widget.go(DqPage.lineup)),
        ],
      ),
    );
  }

  /// De zoekbalk met uitklap-pijltje.
  Widget _zoekBalk() {
    final actief = _categorieen.where((c) => c.$2 == _filter).toList();
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: Border.all(color: _paneelOpen ? DQ.paper : DQ.line2),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(LucideIcons.search, size: 16, color: DQ.muted),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _zoekTekst,
              onTap: () => setState(() => _paneelOpen = true),
              onChanged: (_) => setState(() => _paneelOpen = true),
              style: inter(11, weight: FontWeight.w600, color: Colors.white),
              cursorColor: DQ.lime,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Zoek stage, eten, drinken…',
                hintStyle: inter(
                  11,
                  weight: FontWeight.w500,
                  color: const Color(0xFF656565),
                ),
              ),
            ),
          ),
          // Gekozen categorie als labeltje, met kruisje om te wissen
          if (actief.isNotEmpty)
            Tap(
              onTap: () => setState(() => _filter = ''),
              child: Container(
                height: 26,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                color: DQ.paper,
                child: Row(
                  children: [
                    DqIcon(actief.first.$3, size: 11, color: DQ.dark),
                    const SizedBox(width: 4),
                    Text(actief.first.$1, style: inter(7, color: DQ.dark)),
                    const SizedBox(width: 4),
                    const Icon(LucideIcons.x, size: 11, color: DQ.dark),
                  ],
                ),
              ),
            ),
          // Uitklap-pijltje
          Tap(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() => _paneelOpen = !_paneelOpen);
            },
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                _paneelOpen ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Het uitklap-paneel: categorieën + resultaten.
  Widget _paneel() {
    final resultaten = _resultaten;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF151515),
        border: Border(
          left: BorderSide(color: DQ.paper),
          right: BorderSide(color: DQ.paper),
          bottom: BorderSide(color: DQ.paper),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('CATEGORIE', style: inter(7, spacing: 1.3, color: DQ.muted)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (label, soort, picto) in _categorieen)
                Tap(
                  onTap: () =>
                      setState(() => _filter = _filter == soort ? '' : soort),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      color: _filter == soort ? DQ.paper : Colors.transparent,
                      border: Border.all(
                        color: _filter == soort ? DQ.paper : DQ.line2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DqIcon(
                          picto,
                          size: 12,
                          color: _filter == soort ? DQ.dark : DQ.muted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          label,
                          style: inter(
                            8,
                            weight: FontWeight.w800,
                            color: _filter == soort ? DQ.dark : DQ.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${resultaten.length} RESULTATEN',
            style: inter(7, spacing: 1.3, color: DQ.muted),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                for (final r in resultaten)
                  Tap(
                    onTap: () => _gaNaar(r),
                    child: Container(
                      height: 46,
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: DQ.line)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            color: r.kleur,
                            child: DqIcon(r.picto, size: 15, color: DQ.dark),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              r.titel,
                              style: bc(16, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(r.lopen, style: inter(8, color: DQ.muted)),
                          const SizedBox(width: 6),
                          const Icon(
                            LucideIcons.chevronRight,
                            size: 14,
                            color: Color(0xFF555555),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (resultaten.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Niets gevonden.',
                      style: inter(
                        10,
                        weight: FontWeight.w500,
                        color: DQ.muted,
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

class _FestivalMap extends StatelessWidget {
  const _FestivalMap({
    required this.filter,
    required this.selected,
    required this.onSelect,
  });

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
              const Positioned.fill(
                child: CustomPaint(painter: _GridPainter()),
              ),
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
                  child: const CustomPaint(
                    size: Size(170, 370),
                    painter: _LakePainter(),
                  ),
                ),
              ),
              Positioned(left: 20, top: 70, child: _Zone('CAMPSITE', 23)),
              Positioned(right: 25, bottom: 50, child: _Zone('WASTELANDS', 18)),
              Positioned(
                left: w * 0.42,
                top: 80,
                child: _StageMarker(
                  'RED',
                  DQ.red,
                  selected == 'RED STAGE',
                  () => onSelect('RED STAGE'),
                ),
              ),
              Positioned(
                left: w * 0.18,
                bottom: 83,
                child: _StageMarker(
                  'BLUE',
                  DQ.blue,
                  selected == 'BLUE STAGE',
                  () => onSelect('BLUE STAGE'),
                ),
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
              Positioned(
                right: w * 0.25,
                top: 118,
                child: _Service(DQ.cyan, 'Waterpunt', fade('WATER')),
              ),
              Positioned(
                left: w * 0.23,
                top: 208,
                child: _Service(DQ.yellow, 'Eten', fade('FOOD')),
              ),
              Positioned(
                right: w * 0.33,
                bottom: 72,
                child: _Service(DQ.lime, 'Wc', fade('WC')),
              ),
              Positioned(
                left: w * 0.54,
                top: 220,
                child: const _CrewDot('MA', DQ.lime),
              ),
              Positioned(
                left: w * 0.27,
                top: 140,
                child: const _CrewDot('EM', DQ.cyan),
              ),
              Positioned(
                left: w * 0.47,
                bottom: 77,
                child: Container(
                  width: 39,
                  height: 39,
                  decoration: const BoxDecoration(
                    color: Color(0x33FF2134),
                    shape: BoxShape.circle,
                  ),
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
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Color(0x55000000),
                        ],
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
                  child: const DqIcon('Target', color: DQ.dark),
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
  const _Road({
    required this.left,
    required this.top,
    required this.width,
    required this.angle,
  });

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
    child: Text(
      label,
      style: bc(size, spacing: 2, color: const Color(0xFF494949)),
    ),
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
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 18,
                    ),
                  ]
                : null,
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
  final Object icon;
  final double opacity;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    duration: const Duration(milliseconds: 200),
    opacity: opacity,
    child: Container(
      width: 31,
      height: 31,
      color: color,
      child: DqIcon(icon, size: 16, color: DQ.dark),
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
                  style: inter(
                    7,
                    weight: FontWeight.w800,
                    spacing: 1.2,
                    color: DQ.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(selected, style: bc(25, color: DQ.dark)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const DqIcon('Stages', size: 13, color: DQ.red),
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
                    const DqIcon('Navigatie', size: 20, color: Colors.white),
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
