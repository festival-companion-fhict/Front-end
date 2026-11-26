import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';
import '../widgets/festival_kaart.dart';

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
