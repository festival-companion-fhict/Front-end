import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_shell.dart';
import 'data/instellingen.dart';
import 'data/taal.dart';
import 'data/weer.dart';
import 'theme/dq_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Instellingen.laad(); // bewaarde aan/uit-keuzes ophalen
  await Taal.laad(); // NL of EN
  Weer.start(); // het weer ophalen (en elke 15 min opnieuw)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const DefqonApp());
}

class DefqonApp extends StatelessWidget {
  const DefqonApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kies je een andere taal? Dan bouwt de app zich helemaal opnieuw op.
    return ValueListenableBuilder<String>(
      valueListenable: Taal.huidig,
      builder: (context, taal, _) => MaterialApp(
        key: ValueKey(taal),
        title: 'DEFQON.1 Companion',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const AppShell(),
      ),
    );
  }
}
