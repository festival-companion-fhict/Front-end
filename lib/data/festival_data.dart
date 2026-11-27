import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/dq_theme.dart';

const _apiBaseUrl = 'https://func-festival-api.azurewebsites.net/api';

/// Eén optreden in de line-up.
class Act {
  const Act(
    this.dag,
    this.time,
    this.end,
    this.artist,
    this.stage, {
    this.genre = 'OVERIG',
    this.info = '',
  });

  final String dag; // bijv. 'SAT 28'
  final String time; // begintijd, bijv. '18:45'
  final String end; // eindtijd
  final String artist; // in HOOFDLETTERS
  final String stage; // zonder 'STAGE', bijv. 'RED'
  final String genre; // bijv. 'HARDSTYLE'
  final String info; // omschrijving van de artiest ('' = nog leeg)

  /// De naam zoals hij op de kaart staat, bijv. 'RED STAGE'.
  String get kaartNaam => stage == 'STAMPKROEG' ? 'STAMPKROEG' : '$stage STAGE';

  /// Uniek kenmerk van dit optreden (voor MIJN SCHEMA).
  String get sleutel => '$dag|$time|$artist';

  bool get isLive => artist == 'POWER HOUR' && dag == 'SAT 28';
}

enum LineupStatus { notLoaded, loading, loaded, error }

List<Act> lineup = const [];
LineupStatus lineupStatus = LineupStatus.notLoaded;
String? lineupError;
Future<void>? _lineupRequest;

/// Haalt optredens en artiestgegevens op en combineert ze tot de line-up.
Future<void> laadLineup() {
  if (lineupStatus == LineupStatus.loading) return _lineupRequest!;
  if (lineupStatus == LineupStatus.loaded) return Future.value();

  lineupStatus = LineupStatus.loading;
  lineupError = null;
  final request = _haalLineupOp();
  _lineupRequest = request;
  return request;
}

Future<void> _haalLineupOp() async {
  try {
    final responses = await Future.wait([
      http.get(Uri.parse('$_apiBaseUrl/optredens')),
      http.get(Uri.parse('$_apiBaseUrl/artiesten')),
    ]).timeout(const Duration(seconds: 15));

    for (final response in responses) {
      if (response.statusCode != 200) {
        throw Exception('API returned status ${response.statusCode}');
      }
    }

    final optredens = _decodeList(responses[0].body, 'optredens');
    final artiesten = _decodeList(responses[1].body, 'artiesten');
    lineup = parseLineupData(optredens, artiesten);
    if (gekozenAct == null && lineup.isNotEmpty) gekozenAct = lineup.first;
    lineupStatus = LineupStatus.loaded;
  } catch (error) {
    lineupError = error.toString();
    lineupStatus = LineupStatus.error;
  }
}

List<Map<String, dynamic>> _decodeList(String body, String naam) {
  final decoded = jsonDecode(body);
  if (decoded is! List) {
    throw FormatException('API returned an unexpected $naam format');
  }
  return decoded.map((item) {
    if (item is! Map<String, dynamic>) {
      throw FormatException('API returned an invalid $naam record');
    }
    return item;
  }).toList();
}

/// Zet de responses van de optredens- en artiesten-endpoints om naar acts.
List<Act> parseLineupData(
  List<Map<String, dynamic>> optredens,
  List<Map<String, dynamic>> artiesten,
) {
  final artiestenOpId = <int, Map<String, dynamic>>{
    for (final artiest in artiesten) (artiest['id'] as num).toInt(): artiest,
  };
  final gesorteerd = [...optredens]
    ..sort((a, b) {
      final startVergelijking = DateTime.parse(
        a['starttijd'] as String,
      ).compareTo(DateTime.parse(b['starttijd'] as String));
      if (startVergelijking != 0) return startVergelijking;
      final stageVergelijking = (a['podium_naam'] as String).compareTo(
        b['podium_naam'] as String,
      );
      if (stageVergelijking != 0) return stageVergelijking;
      return (a['artiest_naam'] as String).compareTo(
        b['artiest_naam'] as String,
      );
    });

  final gezien = <String>{};
  final acts = <Act>[];
  for (final optreden in gesorteerd) {
    final sleutel =
        '${optreden['artiest_id']}|${optreden['starttijd']}|'
        '${optreden['eindtijd']}|${optreden['podium_id']}';
    if (!gezien.add(sleutel)) continue;

    final artiest = artiestenOpId[(optreden['artiest_id'] as num).toInt()];
    final start = DateTime.parse(optreden['starttijd'] as String).toUtc();
    final eind = DateTime.parse(optreden['eindtijd'] as String).toUtc();
    const weekdagen = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final genre = (artiest?['genre'] as String?)?.trim().toUpperCase();

    acts.add(
      Act(
        '${weekdagen[start.weekday - 1]} ${start.day}',
        _formatTijd(start),
        _formatTijd(eind),
        (optreden['artiest_naam'] as String).toUpperCase(),
        (optreden['podium_naam'] as String).toUpperCase(),
        genre: genre == null || genre.isEmpty ? 'OVERIG' : genre,
        info: (artiest?['omschrijving'] as String?) ?? '',
      ),
    );
  }
  return acts;
}

String _formatTijd(DateTime tijd) =>
    '${tijd.hour.toString().padLeft(2, '0')}:'
    '${tijd.minute.toString().padLeft(2, '0')}';

/// Alle festivaldagen, in volgorde (bijv. THU 26, FRI 27, ...).
List<String> get festivalDagen {
  final dagen = <String>[];
  for (final a in lineup) {
    if (!dagen.contains(a.dag)) dagen.add(a.dag);
  }
  return dagen;
}

/// Alle genres die in de line-up voorkomen, met OVERIG altijd als laatste.
List<String> get alleGenres {
  final genres = lineup.map((a) => a.genre).toSet().toList()..sort();
  if (genres.remove('OVERIG')) genres.add('OVERIG');
  return genres;
}

/// Kleur per genre. Een nieuw genre in de database krijgt vanzelf grijs.
Color genreKleur(String genre) => switch (genre) {
  'HARDSTYLE' => DQ.cyan,
  'EUPHORIC' => DQ.aqua,
  'RAWSTYLE' => DQ.red,
  'HARDCORE' => DQ.orange,
  'UPTEMPO' => DQ.fuchsia,
  'CLASSICS' => DQ.yellow,
  'FRENCHCORE' => const Color(0xFF8C7BFF),
  'HARD TECHNO' => DQ.lime,
  _ => const Color(0xFFA0A0A0),
};

/// Zoek een act op naam (en eventueel stage), bijv. zoekAct('KELTEK').
/// Niet gevonden? Dan krijg je null.
Act? zoekAct(String naam, {String stage = ''}) {
  for (final act in lineup) {
    if (act.artist == naam.toUpperCase() &&
        (stage == '' || act.stage == stage)) {
      return act;
    }
  }
  return null;
}

/// Welke artiest er op de artiestpagina staat.
/// Zet dit vóór je naar DqPage.artist gaat.
Act? gekozenAct;

class CrewMember {
  const CrewMember(
    this.initials,
    this.name,
    this.location,
    this.color, {
    this.darkText = true,
    this.kaartPlek = '',
  });

  final String initials;
  final String name;
  final String location;
  final Color color;
  final bool darkText;
  final String kaartPlek; // naam van de plek op de kaart ('' = verborgen)
}

const crew = <CrewMember>[
  CrewMember('MA', 'MOAAD', 'RED STAGE', DQ.lime, kaartPlek: 'RED STAGE'),
  CrewMember(
    'EM',
    'EMI',
    'FOOD DISTRICT',
    DQ.cyan,
    kaartPlek: 'FOOD COURT NOORD',
  ),
  CrewMember(
    'FH',
    'FABIAN',
    'BLUE STAGE',
    DQ.blue,
    darkText: false,
    kaartPlek: 'BLUE STAGE',
  ),
  CrewMember(
    'WD',
    'WALID',
    'HIDDEN',
   Colors.white
  ),
];

class NewsItem {
  const NewsItem(
    this.time,
    this.category,
    this.title,
    this.text, {
    this.body = '',
    this.artiest = '',
  });

  final String time;
  final String category; // PROGRAMMA, VERVOER, WEER, VEILIGHEID of ALGEMEEN
  final String title;
  final String text;
  final String body; // het hele verhaal (voor de nieuwspagina)
  final String artiest; // over welke artiest gaat het? ('' = geen artiest)
}

/// Voorbeeldnieuws. Later uit de database (tabel aankondigingen).
const news = <NewsItem>[
  NewsItem(
    '18:40',
    'PROGRAMMA',
    'Zatox toegevoegd aan vrijdag',
    'Zatox speelt vrijdag om 17:00 een extra set op RED.',
    body:
        'Goed nieuws voor de uptempo-fans: Zatox komt een extra set spelen. '
        'Vrijdag van 17:00 tot 18:00 op RED STAGE.\n\n'
        'Tik op het hartje in het SCHEMA om hem aan MIJN SCHEMA toe te voegen.',
    artiest: 'ZATOX',
  ),
  NewsItem(
    '18:31',
    'VERVOER',
    'Extra pendelbussen vannacht',
    'Vanaf 23:30 rijdt iedere tien minuten een bus naar station Dronten.',
    body:
        'Omdat het vanavond extra druk wordt, zetten we meer pendelbussen in. '
        'Vanaf 23:30 vertrekt er iedere tien minuten een bus van de bushalte bij de hoofdingang '
        'naar station Dronten. De laatste bus vertrekt om 03:30.\n\n'
        'Tip: loop niet allemaal tegelijk naar de uitgang na de laatste act. '
        'Volg de borden BUS en luister naar de crew.',
  ),
  NewsItem(
    '17:55',
    'PROGRAMMA',
    'Stagewissel: D-Sturb',
    'D-Sturb speelt om 19:00 op BLUE in plaats van BLACK.',
    body:
        'Door een technisch probleem op BLACK STAGE verhuist de show van D-Sturb naar BLUE STAGE. '
        'De tijd blijft hetzelfde: 19:00 tot 20:00.\n\n'
        'Heb je een herinnering gezet? Die is automatisch aangepast. '
        'Je vindt BLUE STAGE op de kaart via het zoeken.',
  ),
  NewsItem(
    '17:10',
    'ALGEMEEN',
    'KELTEK speelt vanavond een nieuwe track',
    'Tijdens zijn set op UV draait KELTEK voor het eerst een nieuwe track.',
    body:
        'KELTEK heeft laten weten dat hij vanavond op UV STAGE een gloednieuwe track draait. '
        'Zijn set begint om 18:45.\n\n'
        'Wees op tijd: bij UV is het rond die tijd druk.',
    artiest: 'KELTEK',
  ),
  NewsItem(
    '16:20',
    'WEER',
    'Droog en warm tot vanavond',
    'Verwachte temperatuur om 20:00 is 21°C. UV-index neemt af.',
    body:
        'Het blijft de hele middag droog en zonnig. Rond 20:00 is het nog 21°C, '
        'daarna koelt het langzaam af naar 15°C.\n\n'
        'Drink genoeg water: bij alle waterpunten is gratis water. '
        'Smeer je in en zoek af en toe de schaduw op.',
  ),
];
