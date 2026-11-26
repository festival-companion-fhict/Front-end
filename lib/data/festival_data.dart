import 'package:flutter/material.dart';

import '../theme/dq_theme.dart';

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

/// Voorbeelddata. De backend koppelt hier later de database aan.
const voorbeeldLineup = <Act>[
  Act('THU 26', '18:00', '19:00', 'ANGERFIST', 'BLACK', genre: 'HARDCORE'),
  Act('THU 26', '19:00', '20:00', 'WILDSTYLEZ', 'RED', genre: 'HARDSTYLE'),
  Act('FRI 27', '17:00', '18:00', 'ZATOX', 'RED', genre: 'UPTEMPO'),
  Act('FRI 27', '18:00', '19:00', 'D-STURB', 'BLUE', genre: 'RAWSTYLE'),
  Act('SAT 28', '18:00', '18:45', 'JAY REEVE', 'UV', genre: 'HARDSTYLE'),
  Act('SAT 28', '18:00', '19:00', 'THE DARKRAVER', 'GOLD', genre: 'CLASSICS'),
  Act('SAT 28', '18:00', '19:00', 'MANJI', 'GREEN', genre: 'HARD TECHNO'),
  Act('SAT 28', '18:00', '19:00', 'FURYAN', 'SILVER', genre: 'FRENCHCORE'),
  Act('SAT 28', '18:15', '18:45', 'ADJUZT', 'RED', genre: 'HARDSTYLE'),
  Act('SAT 28', '18:45', '19:30', 'KELTEK', 'UV', genre: 'HARDSTYLE'),
  Act('SAT 28', '19:00', '20:00', 'POWER HOUR', 'RED'),
  Act(
    'SAT 28',
    '19:00',
    '19:45',
    'THE DOPE DOCTOR',
    'YELLOW',
    genre: 'UPTEMPO',
  ),
  Act(
    'SAT 28',
    '20:45',
    '21:45',
    'SUB ZERO PROJECT',
    'RED',
    genre: 'HARDSTYLE',
  ),
  Act('SUN 29', '18:00', '19:00', 'SEFA', 'BLACK', genre: 'HARDCORE'),
  Act('SUN 29', '19:00', '20:00', 'BRENNAN HEART', 'RED', genre: 'HARDSTYLE'),
];

/// De line-up die de app laat zien (nu nog de voorbeelddata).
List<Act> lineup = voorbeeldLineup;

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
/// Niet gevonden? Dan krijg je de eerste act van de lijst.
Act zoekAct(String naam, {String stage = ''}) => lineup.firstWhere(
  (a) => a.artist == naam.toUpperCase() && (stage == '' || a.stage == stage),
  orElse: () => lineup.first,
);

/// Welke artiest er op de artiestpagina staat.
/// Zet dit vóór je naar DqPage.artist gaat.
Act gekozenAct = zoekAct('KELTEK');

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
