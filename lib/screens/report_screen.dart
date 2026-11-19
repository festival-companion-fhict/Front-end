import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 9),
    child: Text(text, style: inter(8, spacing: 1.3, color: DQ.muted)),
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
                const Icon(LucideIcons.info, size: 20, color: DQ.yellow),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Voor direct gevaar gebruik je altijd de rode SOS-knop. Deze melding gaat naar het terreinteam.',
                    style: inter(10, weight: FontWeight.w500, color: const Color(0xFFBBBBBB), height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          _label('WAT WIL JE MELDEN?'),
          Row(
            children: [
              for (final (i, c) in const ['AFVAL', 'TOILET', 'KAPOT', 'OVERIG'].indexed) ...[
                if (i > 0) const SizedBox(width: 5),
                Expanded(
                  child: Tap(
                    onTap: () => setState(() => _category = c),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _category == c ? DQ.lime : const Color(0xFF141414),
                        border: Border.all(color: _category == c ? DQ.lime : DQ.line2),
                      ),
                      child: Text(c, style: inter(7, color: _category == c ? DQ.dark : DQ.muted)),
                    ),
                  ),
                ),
              ],
            ],
          ),
          _label('WAT IS ER AAN DE HAND?'),
          SizedBox(
            height: 135,
            child: TextField(
              controller: _text,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: inter(12, weight: FontWeight.w500, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF151515),
                hintText: 'Bijvoorbeeld: de watertap naast RED Stage lekt...',
                hintStyle: inter(12, weight: FontWeight.w500, color: const Color(0xFF656565)),
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
          Tap(
            onTap: () => setState(() => _location = !_location),
            child: Container(
              constraints: const BoxConstraints(minHeight: 66),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: DQ.line)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 20, color: DQ.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LIVE LOCATIE TOEVOEGEN',
                          style: inter(9, weight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Bij RED Stage · nauwkeurig tot 8 meter',
                          style: inter(7, weight: FontWeight.w500, color: DQ.muted),
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
                    child: _location ? const Icon(LucideIcons.check, size: 14, color: DQ.dark) : null,
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
                  const Icon(LucideIcons.send, size: 18, color: Colors.white),
                  const SizedBox(width: 9),
                  Text('VERSTUUR ANONIEM', style: inter(9, color: Colors.white)),
                  const Spacer(),
                  const Icon(LucideIcons.arrowRight, size: 18, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _done() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
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
                child: const Icon(LucideIcons.check, size: 34, color: DQ.dark),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text('MELDING ONTVANGEN', style: inter(8, color: DQ.lime, spacing: 2)),
          const SizedBox(height: 7),
          Text('THANKS,\nWARRIOR', style: bc(62, italic: true, height: 0.85)),
          const SizedBox(height: 14),
          Text(
            'Het terreinteam heeft je melding ontvangen. Je locatie is anoniem meegestuurd.',
            style: inter(11, weight: FontWeight.w500, color: const Color(0xFF999999), height: 1.5),
          ),
          const SizedBox(height: 22),
          DashedBox(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REFERENTIE',
                    style: inter(7, weight: FontWeight.w500, spacing: 1, color: DQ.muted),
                  ),
                  const SizedBox(height: 4),
                  Text('#DQ-1408', style: bc(25)),
                  const SizedBox(height: 7),
                  Text(
                    'Verwachte reactie · 10 min',
                    style: inter(7, weight: FontWeight.w500, spacing: 1, color: DQ.muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Tap(
            onTap: () => setState(() {
              _sent = false;
              _text.clear();
            }),
            child: Container(
              height: 50,
              color: DQ.paper,
              alignment: Alignment.center,
              child: Text('NIEUWE MELDING', style: inter(9, color: DQ.dark)),
            ),
          ),
        ],
      ),
    );
  }
}
