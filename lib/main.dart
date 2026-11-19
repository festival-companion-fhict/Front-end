import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_shell.dart';
import 'theme/dq_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const DefqonApp());
}

class DefqonApp extends StatelessWidget {
  const DefqonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEFQON.1 Companion',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const AppShell(),
    );
  }
}
