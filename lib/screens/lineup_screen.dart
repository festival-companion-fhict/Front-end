import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_shell.dart';
import '../data/festival_data.dart';
import '../data/festivaltijd.dart';
import '../data/instellingen.dart';
import '../data/taal.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';
import '../widgets/festival_kaart.dart';

/// Scherm 4: LINE-UP met dagen, stage-filter en favorieten.
class LineupScreen extends StatefulWidget {
  const LineupScreen({super.key, required this.go});

  final Go go;

  @override
  State<LineupScreen> createState() => _LineupScreenState();
}

class _LineupScreenState extends State<LineupScreen> {
  String _day = 'SAT 28';
  String _stage = 'ALLE STAGES';
  String _genre = 'ALLE GENRES';
  bool _mijnSchema = false; // false = hele schema, true = alleen ♡
  bool _zoekOpen = false; // is de zoekbalk open?
  final _zoek = TextEditingController();
  final _nuKey = GlobalKey(); // de act waar de lijst naartoe springt
  String? _gesprongenOp; // op welke dag we al naar "nu" zijn gesprongen

  @override
  void initState() {
        super.initState();
    if (FestivalTijd.vandaag.isNotEmpty) _day = FestivalTijd.vandaag;
    FestivalTijd.tik.addListener(_ververs);
    _loadLineup();
  }

  void _ververs() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    FestivalTijd.tik.removeListener(_ververs);
    _zoek.dispose();
    super.dispose();
  }

  void _loadLineup() {
    laadLineup().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (lineupStatus != LineupStatus.loaded || lineup.isEmpty) {
      return _lineupStatusView();
    }

    final dagen = festivalDagen;
    if (!dagen.contains(_day)) _day = dagen.first;
    final zoek = _zoek.text.trim().toUpperCase();

    // Eerst alles van deze dag (of alles wat je bewaard hebt)
    final basis = _mijnSchema
        ? lineup.where((a) => Instellingen.bewaard.contains(a.sleutel))
        : lineup.where((a) => a.dag == _day);
    final acts = basis
        .where((a) => _stage == 'ALLE STAGES' || a.kaartNaam == _stage)
        .where((a) => _genre == 'ALLE GENRES' || a.genre == _genre)
        .where(
          (a) =>
              zoek.isEmpty ||
              a.artist.contains(zoek) ||
              a.stage.contains(zoek) ||
              a.genre.contains(zoek),
        )
        .toList();

    // De eerste act die nu bezig is of nog moet komen (alleen vandaag).
    // Daar springt de lijst naartoe. Naar boven scrollen = eerder op de dag.
    final nuIndex = !_mijnSchema && _day == FestivalTijd.vandaag
        ? acts.indexWhere((a) => FestivalTijd.status(a) != ActStatus.geweest)
        : -1;
    if (nuIndex > 0 && _gesprongenOp != _day) {
      _gesprongenOp = _day;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final plek = _nuKey.currentContext;
        if (plek != null) {
          Scrollable.ensureVisible(
            plek,
            duration: const Duration(milliseconds: 400),
          );
        }
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeading(
                  kicker: 'CHOOSE YOUR BATTLES',
                  title: 'LINE-UP',
                  action: OutlineSquare(
                    icon: _zoekOpen ? LucideIcons.x : LucideIcons.search,
                    onTap: () => setState(() {
                      _zoekOpen = !_zoekOpen;
                      if (!_zoekOpen) _zoek.clear();
                    }),
                  ),
                ),
                // Zoekbalk (alleen als je op het vergrootglas hebt getikt)
                if (_zoekOpen) ...[_zoekBalk(), const SizedBox(height: 13)],
                // SCHEMA of MIJN SCHEMA
                Row(
                  children: [
                    _modusKnop('SCHEMA', !_mijnSchema, () {
                      setState(() => _mijnSchema = false);
                    }),
                    const SizedBox(width: 7),
                    _modusKnop(
                      '${t('MIJN SCHEMA')} · ${Instellingen.bewaard.length}',
                      _mijnSchema,
                      () => setState(() => _mijnSchema = true),
                      hartje: true,
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                // Dagen (niet bij MIJN SCHEMA: daar zie je alle dagen)
                if (!_mijnSchema) ...[
                  _dagen(dagen),
                  const SizedBox(height: 13),
                ],
                // Twee keuzelijsten: STAGE en GENRE
                Row(
                  children: [
                    Expanded(
                      child: _keuzeVak('STAGE', _stage, () async {
                        final keuze = await _kiesUitLijst('KIES EEN STAGE', [
                          'ALLE STAGES',
                          ..._stagesVanDeDag(),
                        ], _stage);
                        if (keuze != null) setState(() => _stage = keuze);
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _keuzeVak('GENRE', _genre, () async {
                        final keuze = await _kiesUitLijst(
                          'KIES JE SOUND',
                          ['ALLE GENRES', ...alleGenres],
                          _genre,
                          aantallen: {
                            'ALLE GENRES': basis.length,
                            for (final g in alleGenres)
                              g: basis.where((a) => a.genre == g).length,
                          },
                        );
                        if (keuze != null) setState(() => _genre = keuze);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(height: 1, color: DQ.line),
          for (final (i, act) in acts.indexed)
            _ActRow(
              key: i == nuIndex ? _nuKey : null,
              act: act,
              number: i + 1,
              toonDag: _mijnSchema,
              saved: Instellingen.bewaard.contains(act.sleutel),
              onOpen: () {
                gekozenAct = act;
                widget.go(DqPage.artist);
              },
              onSave: () async {
                await Instellingen.wisselBewaard(act.sleutel);
                setState(() {});
              },
            ),
          if (acts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                _mijnSchema && Instellingen.bewaard.isEmpty
                    ? t(
                        'Nog niets bewaard. Tik op het hartje bij een act om hem aan MIJN SCHEMA toe te voegen.',
                      )
                    : t(
                        'Geen acts gevonden. Kies een andere dag, stage of genre.',
                      ),
                style: inter(11, weight: FontWeight.w500, color: DQ.muted),
              ),
            ),
        ],
      ),
    );
  }

  Widget _lineupStatusView() {
    final fout = lineupStatus == LineupStatus.error;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!fout && lineupStatus != LineupStatus.loaded)
              const CircularProgressIndicator(color: DQ.lime),
            const SizedBox(height: 14),
            Text(
              fout
                  ? '${t('Line-up laden mislukt:')} $lineupError'
                  : lineup.isEmpty
                  ? t('Er staan geen optredens in de database.')
                  : t('Line-up laden...'),
              textAlign: TextAlign.center,
              style: inter(11, weight: FontWeight.w600, color: DQ.muted),
            ),
            if (fout) ...[
              const SizedBox(height: 14),
              Tap(
                onTap: _loadLineup,
                child: Text(
                  t('OPNIEUW PROBEREN'),
                  style: inter(10, weight: FontWeight.w800, color: DQ.lime),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Alle stages die op de gekozen dag spelen, op alfabet.
  List<String> _stagesVanDeDag() {
    final stages = lineup
        .where((a) => _mijnSchema || a.dag == _day)
        .map((a) => a.kaartNaam)
        .toSet()
        .toList();
    return stages..sort();
  }

  Widget _zoekBalk() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: Border.all(color: DQ.paper),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.search, size: 16, color: DQ.muted),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _zoek,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              style: inter(11, weight: FontWeight.w600, color: Colors.white),
              cursorColor: DQ.lime,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: t('Zoek artiest, stage of genre…'),
                hintStyle: inter(
                  11,
                  weight: FontWeight.w500,
                  color: const Color(0xFF656565),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SCHEMA / MIJN SCHEMA-knop.
  Widget _modusKnop(
    String tekst,
    bool gekozen,
    VoidCallback onTap, {
    bool hartje = false,
  }) {
    final kleur = gekozen ? Colors.white : DQ.muted;
    return Expanded(
      child: Tap(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: gekozen ? DQ.red : Colors.transparent,
            border: Border.all(color: gekozen ? DQ.red : DQ.line2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hartje) ...[
                DqIcon('Vol_hart', size: 14, color: gekozen ? kleur : DQ.red),
                const SizedBox(width: 6),
              ],
              Text(t(tekst), style: inter(9, color: kleur)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dagen(List<String> dagen) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: DQ.line2)),
      child: Row(
        children: [
          for (final (i, day) in dagen.indexed)
            Expanded(
              child: Tap(
                onTap: () => setState(() {
                  _day = day;
                  _stage = 'ALLE STAGES';
                }),
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: _day == day ? DQ.paper : DQ.dark,
                    border: i < dagen.length - 1
                        ? const Border(right: BorderSide(color: DQ.line2))
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t('JUNI'),
                        style: inter(
                          7,
                          weight: FontWeight.w500,
                          spacing: 1,
                          color: _day == day ? DQ.dark : DQ.muted,
                        ),
                      ),
                      Text(
                        day,
                        style: bc(19, color: _day == day ? DQ.dark : DQ.muted),
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

  /// Vak met een kopje en de huidige keuze, bijv. GENRE / HARDSTYLE ▾.
  Widget _keuzeVak(String kop, String waarde, VoidCallback onTap) {
    final actief = !waarde.startsWith('ALLE');
    return Tap(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: actief ? DQ.paper : DQ.line2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t(kop), style: inter(7, spacing: 1.2, color: DQ.muted)),
                  const SizedBox(height: 2),
                  Text(
                    t(waarde),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bc(17, color: Colors.white),
                  ),
                ],
              ),
            ),
            const DqIcon(LucideIcons.chevronDown, size: 18, color: DQ.muted),
          ],
        ),
      ),
    );
  }

  /// Opent een lijstje onderin het scherm. Geeft je keuze terug.
  Future<String?> _kiesUitLijst(
    String titel,
    List<String> opties,
    String huidig, {
    Map<String, int> aantallen = const {},
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: DQ.dark,
      shape: const RoundedRectangleBorder(),
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheet).height * 0.75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 6, color: DQ.lime),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(t(titel), style: bc(32, color: Colors.white)),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  children: [
                    for (final optie in opties)
                      Tap(
                        onTap: () => Navigator.of(sheet).pop(optie),
                        child: Container(
                          height: 54,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: DQ.line)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                color: optie.startsWith('ALLE')
                                    ? Colors.transparent
                                    : (opties.first == 'ALLE GENRES'
                                          ? genreKleur(optie)
                                          : stageKleur(optie)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  t(optie),
                                  style: bc(
                                    19,
                                    color: optie == huidig
                                        ? DQ.lime
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              if (aantallen[optie] != null) ...[
                                Text(
                                  '${aantallen[optie]} ACTS',
                                  style: inter(8, color: DQ.muted),
                                ),
                                const SizedBox(width: 10),
                              ],
                              if (optie == huidig)
                                const DqIcon(
                                  LucideIcons.check,
                                  size: 18,
                                  color: DQ.lime,
                                ),
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
      ),
    );
  }
}

class _ActRow extends StatelessWidget {
  const _ActRow({
    super.key,
    required this.act,
    required this.number,
    required this.saved,
    this.toonDag = false,
    required this.onOpen,
    required this.onSave,
  });

  final Act act;
  final int number;
  final bool saved;
  final bool toonDag; // bij MIJN SCHEMA ook de dag laten zien
  final VoidCallback onOpen;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final status = FestivalTijd.status(act);
    final live = status == ActStatus.live;
    const bg = DQ.dark;
    return Opacity(
      opacity: status == ActStatus.geweest ? 0.4 : 1,
      child: Container(
      height: 76,
      decoration: BoxDecoration(
        border: const Border(bottom: BorderSide(color: DQ.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 6, color: stageKleur(act.kaartNaam)),
          Expanded(
            child: Tap(
              onTap: onOpen,
              child: Container(
                color: bg,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    // Voortgangsbalk onderin: hoe ver de set al is
                    if (live)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 3,
                        child: Container(
                          color: const Color(0x30FFFFFF),
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: FestivalTijd.voortgang(act),
                            child: Container(color: DQ.acid),
                          ),
                        ),
                      ),
                    Positioned(
                      right: 6,
                      bottom: -18,
                      child: Text(
                        number.toString().padLeft(2, '0'),
                        style: bc(58, color: const Color(0x08FFFFFF)),
                      ),
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
                              Text(
                                act.time,
                                style: bc(18, color: Colors.white),
                              ),
                              Text(
                                act.end,
                                style: inter(
                                  8,
                                  weight: FontWeight.w500,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  live
                                      ? '${t('LIVE NU')} · ${FestivalTijd.minutenNog(act)} ${t('MIN NOG')}'
                                      : '${toonDag ? '${act.dag} · ' : ''}${act.kaartNaam} · ${t(act.genre)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: inter(
                                    8,
                                    weight: FontWeight.w800,
                                    spacing: 1,
                                    color: live ? Colors.white : DQ.muted,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  act.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: bc(
                                    21,
                                    height: 0.95,
                                    color: Colors.white,
                                  ),
                                ),
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
              child: DqIcon(
                saved ? 'Vol_hart' : 'Hart',
                size: 20,
                color: DQ.red,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
