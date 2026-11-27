import 'dart:async';

import 'package:flutter/material.dart';

import '../data/weer.dart';

/// Klok die elke paar seconden de echte tijd laat zien, bijv. '18:42'.
class Klok extends StatefulWidget {
  const Klok({super.key, this.style});

  final TextStyle? style;

  @override
  State<Klok> createState() => _KlokState();
}

class _KlokState extends State<Klok> {
  DateTime _nu = DateTime.now();
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => setState(() => _nu = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twee(int n) => n.toString().padLeft(2, '0');
    return Text('${twee(_nu.hour)}:${twee(_nu.minute)}', style: widget.style);
  }
}

/// Weer-icoontje. Gebruikt je eigen pictogram (bijv. assets/pictograms/Regen.png).
/// Bestaat dat plaatje nog niet? Dan een standaard-icoon.
class WeerIcoon extends StatelessWidget {
  const WeerIcoon({super.key, this.size = 18, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Weer?>(
    valueListenable: Weer.huidig,
    builder: (_, weer, _) => Image.asset(
      'assets/pictograms/${weer?.pictogram ?? 'Bewolkt'}.png',
      width: size * 1.2,
      height: size * 1.2,
      color: color,
      errorBuilder: (_, _, _) => Icon(
        weer?.reserveIcoon ?? Icons.cloud_outlined,
        size: size * 1.2,
        color: color,
      ),
    ),
  );
}

/// De temperatuur als tekst, bijv. '18°C' ('–°C' zolang hij laadt).
class WeerTemperatuur extends StatelessWidget {
  const WeerTemperatuur({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Weer?>(
    valueListenable: Weer.huidig,
    builder: (_, weer, _) => Text(weer?.temperatuur ?? '–°C', style: style),
  );
}
