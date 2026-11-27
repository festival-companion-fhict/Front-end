import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/taal.dart';
import '../theme/dq_theme.dart';
import '../widgets/common.dart';

/// Scherm 7: MELDEN – iets melden aan het terreinteam.
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _category = 'AFVAL';
  bool _location = true;
  bool _sent = false;
  final _text = TextEditingController();
  Uint8List? _foto; // de gekozen foto (of null als er geen foto is)

  // De soorten meldingen: (naam, pictogram)
  static const _categorieen = <(String, Object)>[
    ('AFVAL', LucideIcons.trash2),
    ('TOILET', 'Wc'),
    ('KAPOT', LucideIcons.wrench),
    ('LEKKAGE', 'Waterpunt'),
    ('VERLOREN', LucideIcons.packageSearch),
    ('OVERIG', 'Melden'),
  ];

  /// Foto kiezen uit je galerij (op de computer: een bestand kiezen).
  Future<void> _kiesFoto() async {
    final bestand = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
    );
    if (bestand == null) return; // niets gekozen
    final bytes = await bestand.readAsBytes();
    setState(() => _foto = bytes);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  // Snelle zinnen per soort melding: tikken in plaats van typen
  static const _snelleZinnen = {
    'AFVAL': ['Prullenbak vol', 'Afval op de grond', 'Glas op de grond'],
    'TOILET': ['Geen wc-papier', 'Verstopt', 'Vies', 'Deur kapot'],
    'KAPOT': ['Lamp kapot', 'Hek kapot', 'Kraan kapot'],
    'LEKKAGE': ['Lekt', 'Plas op de grond', 'Geen water'],
    'VERLOREN': ['Telefoon', 'Portemonnee', 'Sleutels', 'Tas'],
    'OVERIG': ['Te druk', 'Gladde vloer', 'Te donker'],
  };

  /// Kopje met een nummer ervoor, bijv. [1] WAT WIL JE MELDEN?
  Widget _stap(int nummer, String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Row(
      children: [
        Container(
          width: 24,
          height: 24,
          color: DQ.lime,
          alignment: Alignment.center,
          child: Text('$nummer', style: inter(10, color: DQ.dark)),
        ),
        const SizedBox(width: 10),
        Text(t(text), style: inter(9, spacing: 1.3, color: DQ.muted)),
      ],
    ),
  );

  /// Zet een snelle zin in het tekstvak (achter wat er al staat).
  void _voegZinToe(String zin) {
    final huidig = _text.text.trim();
    _text.text = huidig.isEmpty ? zin : '$huidig. $zin';
    setState(() {});
  }

  /// De knoppen met snelle zinnen voor de gekozen soort.
  Widget _zinKnoppen() => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [
      for (final zin in _snelleZinnen[_category] ?? const <String>[])
        Tap(
          onTap: () => _voegZinToe(zin),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(border: Border.all(color: DQ.line2)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DqIcon(LucideIcons.plus, size: 12, color: DQ.lime),
                const SizedBox(width: 6),
                Text(t(zin), style: inter(10, color: Colors.white)),
              ],
            ),
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (_sent) return _done();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeading(kicker: 'GEEN DIRECT GEVAAR?', title: 'MELDEN'),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: const BoxDecoration(
              color: Color(0xFF231F13),
              border: Border(left: BorderSide(color: DQ.yellow, width: 5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DqIcon('Info', size: 20, color: DQ.yellow),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    t('Voor direct gevaar gebruik je altijd de rode SOS-knop. Deze melding gaat naar het terreinteam.'),
                    style: inter(
                      10,
                      weight: FontWeight.w500,
                      color: const Color(0xFFBBBBBB),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          _stap(1, 'WAT WIL JE MELDEN?'),
          // 6 knoppen in 2 rijen van 3
          for (final rij in [
            _categorieen.sublist(0, 3),
            _categorieen.sublist(3),
          ]) ...[
            Row(
              children: [
                for (final (i, (naam, picto)) in rij.indexed) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: Tap(
                      onTap: () => setState(() => _category = naam),
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          color: _category == naam
                              ? DQ.lime
                              : const Color(0xFF141414),
                          border: Border.all(
                            color: _category == naam ? DQ.lime : DQ.line2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DqIcon(
                              picto,
                              size: 18,
                              color: _category == naam ? DQ.dark : DQ.muted,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t(naam),
                              style: inter(
                                7,
                                color: _category == naam ? DQ.dark : DQ.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
          ],
          _stap(2, 'WAT IS ER AAN DE HAND?'),
          _zinKnoppen(),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: TextField(
              controller: _text,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: inter(12, weight: FontWeight.w500, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF151515),
                hintText: t('Bijvoorbeeld: de watertap naast RED Stage lekt...'),
                hintStyle: inter(
                  12,
                  weight: FontWeight.w500,
                  color: const Color(0xFF656565),
                ),
                contentPadding: const EdgeInsets.all(14),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Color(0xFF484848)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: DQ.lime),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _fotoVak(),
          _stap(3, 'WAAR IS HET?'),
          Tap(
            onTap: () => setState(() => _location = !_location),
            child: Container(
              constraints: const BoxConstraints(minHeight: 66),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: DQ.line)),
              ),
              child: Row(
                children: [
                  const DqIcon('Duo_kaart', size: 20, color: DQ.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t('LIVE LOCATIE TOEVOEGEN'),
                          style: inter(
                            9,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          t('Bij RED Stage · nauwkeurig tot 8 meter'),
                          style: inter(
                            7,
                            weight: FontWeight.w500,
                            color: DQ.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      color: _location ? DQ.lime : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: _location ? DQ.lime : DQ.line2),
                    ),
                    child: _location
                        ? const DqIcon(
                            LucideIcons.check,
                            size: 14,
                            color: DQ.dark,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Tap(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() => _sent = true);
            },
            child: Container(
              height: 54,
              color: DQ.red,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const DqIcon(LucideIcons.send, size: 18, color: Colors.white),
                  const SizedBox(width: 9),
                  Text(
                    t('VERSTUUR ANONIEM'),
                    style: inter(9, color: Colors.white),
                  ),
                  const Spacer(),
                  const DqIcon('Pijl_rechts', size: 18, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Knop FOTO TOEVOEGEN, of de gekozen foto met een kruisje om te wissen.
  Widget _fotoVak() {
    final foto = _foto;
    if (foto == null) {
      return Tap(
        onTap: _kiesFoto,
        child: DashedBox(
          color: DQ.line2,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DqIcon(LucideIcons.camera, size: 18, color: DQ.lime),
                const SizedBox(width: 10),
                Text(t('FOTO TOEVOEGEN'), style: inter(9, color: Colors.white)),
                const SizedBox(width: 6),
                Text(
                  t('(optioneel)'),
                  style: inter(9, weight: FontWeight.w500, color: DQ.muted),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: DQ.line2)),
      child: Row(
        children: [
          Image.memory(foto, width: 64, height: 64, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Text(t('FOTO TOEGEVOEGD'), style: inter(9, color: DQ.lime)),
          ),
          OutlineSquare(
            icon: LucideIcons.x,
            size: 40,
            iconColor: Colors.white,
            onTap: () => setState(() => _foto = null),
          ),
        ],
      ),
    );
  }

  Widget _done() {
    final nu = TimeOfDay.now();
    final tijd =
        '${nu.hour.toString().padLeft(2, '0')}:${nu.minute.toString().padLeft(2, '0')}';
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.rotate(
              angle: -5 * 3.14159 / 180,
              child: Container(
                width: 74,
                height: 74,
                color: DQ.lime,
                child: const DqIcon(
                  LucideIcons.check,
                  size: 34,
                  color: DQ.dark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text('${t('MELDING')} #DQ-1408', style: inter(8, color: DQ.lime, spacing: 2)),
          const SizedBox(height: 7),
          Text('THANKS,\nWARRIOR', style: bc(62, italic: true, height: 0.85)),
          const SizedBox(height: 14),
          Text(
            '${t(_category)}${_location ? t(' · je locatie is anoniem meegestuurd') : ''}. '
            '${t('Het terreinteam pakt het op.')}',
            style: inter(
              11,
              weight: FontWeight.w500,
              color: const Color(0xFF999999),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 26),
          // Tijdlijn: wat gebeurt er met je melding?
          _tijdlijnStap('ONTVANGEN', tijd, DQ.lime, eerste: true),
          _tijdlijnStap('IN BEHANDELING', 'verwacht binnen 10 min', DQ.yellow),
          _tijdlijnStap(
            'AFGEHANDELD',
            'je krijgt een melding',
            const Color(0xFF555555),
            laatste: true,
          ),
          const SizedBox(height: 22),
          Tap(
            onTap: () => setState(() {
              _sent = false;
              _text.clear();
              _foto = null;
            }),
            child: Container(
              height: 52,
              color: DQ.paper,
              alignment: Alignment.center,
              child: Text(t('NIEUWE MELDING'), style: inter(9, color: DQ.dark)),
            ),
          ),
        ],
      ),
    );
  }

  /// Eén stap van de tijdlijn: bolletje, lijntje, titel en kleine tekst.
  Widget _tijdlijnStap(
    String titel,
    String tekst,
    Color kleur, {
    bool eerste = false,
    bool laatste = false,
  }) {
    return SizedBox(
      height: 64,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 6,
                  color: eerste ? Colors.transparent : DQ.line2,
                ),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: kleur,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: laatste ? Colors.transparent : DQ.line2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t(titel), style: bc(22, height: 1.1, color: kleur)),
              Text(
                t(tekst),
                style: inter(10, weight: FontWeight.w500, color: DQ.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
