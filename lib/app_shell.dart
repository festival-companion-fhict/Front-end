import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/artist_screen.dart';
import 'screens/crew_screen.dart';
import 'screens/emergency_sheet.dart';
import 'screens/home_screen.dart';
import 'screens/lineup_screen.dart';
import 'screens/map_screen.dart';
import 'screens/news_screen.dart';
import 'screens/profile_drawer.dart';
import 'screens/report_screen.dart';
import 'screens/start_screen.dart';
import 'screens/ticket_screen.dart';
import 'theme/dq_theme.dart';
import 'widgets/chrome.dart';
import 'widgets/common.dart';

/// Alle pagina's van de app.
enum DqPage { home, lineup, map, report, news, crew, ticket, artist }

/// Functie om naar een andere pagina te gaan.
typedef Go = void Function(DqPage page);

/// De "schil" om de app heen: header, live-strook, inhoud, menubalk en SOS-knop.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _startedKey = 'dq-started';

  DqPage _page = DqPage.home;
  bool? _started; // null = nog aan het laden
  bool _emergency = false;
  bool _profile = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) setState(() => _started = prefs.getBool(_startedKey) ?? false);
    });
  }

  Future<void> _start() async {
    setState(() {
      _started = true;
      _page = DqPage.home;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_startedKey, true);
  }

  void _go(DqPage page) => setState(() => _page = page);

  /// Welke tab in de menubalk actief is (artiest en ticket horen bij SCHEMA).
  DqPage get _navPage => _page == DqPage.ticket || _page == DqPage.artist ? DqPage.lineup : _page;

  Widget _content() => switch (_page) {
    DqPage.home => HomeScreen(go: _go),
    DqPage.lineup => LineupScreen(go: _go),
    DqPage.artist => ArtistScreen(go: _go),
    DqPage.map => MapScreen(go: _go),
    DqPage.report => const ReportScreen(),
    DqPage.news => NewsScreen(go: _go),
    DqPage.crew => const CrewScreen(),
    DqPage.ticket => TicketScreen(go: _go, openProfile: () => setState(() => _profile = true)),
  };

  @override
  Widget build(BuildContext context) {
    final started = _started;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: DQ.ink,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          if (started == null)
            const SizedBox.expand()
          else if (!started)
            StartScreen(onStart: _start)
          else
            Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: _page == DqPage.ticket
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            DqHeader(go: _go, openProfile: () => setState(() => _profile = true)),
                            const LiveStrip(),
                          ],
                        ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOut,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: Tween(begin: 0.3, end: 1.0).animate(animation),
                      child: SlideTransition(
                        position: Tween(begin: const Offset(0, 0.012), end: Offset.zero).animate(animation),
                        child: child,
                      ),
                    ),
                    layoutBuilder: (current, previous) => current ?? const SizedBox.shrink(),
                    child: KeyedSubtree(key: ValueKey(_page), child: _content()),
                  ),
                ),
                DqNav(active: _navPage, go: _go),
              ],
            ),

          // Geel-zwarte strepen rechtsboven.
          const Positioned(top: 0, right: 0, child: HazardStripes(width: 115, height: 8)),

          // SOS-knop (niet op het startscherm).
          if (started ?? false)
            Positioned(
              right: 12,
              bottom: 81 + bottomInset,
              child: SosButton(onTap: () => setState(() => _emergency = true)),
            ),

          if (_emergency) EmergencySheet(close: () => setState(() => _emergency = false)),
          if (_profile) ProfileDrawer(close: () => setState(() => _profile = false), go: _go),
        ],
      ),
    );
  }
}
