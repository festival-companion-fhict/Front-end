import 'package:flutter/material.dart';

import '../theme/dq_theme.dart';

/// Eén optreden in de line-up.
class Act {
  const Act(this.time, this.end, this.artist, this.stage, this.accent);

  final String time;
  final String end;
  final String artist;
  final String stage;
  final Color accent;

  bool get isLive => artist == 'POWER HOUR';
}

/// Voorbeelddata. Later kun je dit uit een API of database halen.
const lineup = <Act>[
  Act('13:00', '14:00', 'THE DARKRAVER', 'BLACK', DQ.lime),
  Act('14:00', '15:00', 'KELTEK', 'UV', DQ.cyan),
  Act('15:00', '16:00', 'SOUND RUSH', 'RED', DQ.red),
  Act('16:00', '17:00', 'SUB ZERO PROJECT', 'RED', DQ.lime),
  Act('17:00', '18:00', 'REBELION', 'BLUE', DQ.blue),
  Act('18:00', '19:00', 'POWER HOUR', 'RED', DQ.yellow),
  Act('19:00', '20:00', 'D-STURB', 'BLUE', DQ.cyan),
];

class CrewMember {
  const CrewMember(
    this.initials,
    this.name,
    this.location,
    this.color, {
    this.darkText = true,
  });

  final String initials;
  final String name;
  final String location;
  final Color color;
  final bool darkText;
}

const crew = <CrewMember>[
  CrewMember('MA', 'MOAAD', 'RED STAGE', DQ.lime),
  CrewMember('EM', 'EMI', 'FOOD DISTRICT', DQ.cyan),
  CrewMember('FH', 'FABIAN', 'BLUE STAGE', DQ.blue, darkText: false),
  CrewMember('WD', 'WALID', 'HIDDEN', Colors.white),
];

class NewsItem {
  const NewsItem(this.time, this.category, this.title, this.text);

  final String time;
  final String category;
  final String title;
  final String text;
}

const news = <NewsItem>[
  NewsItem(
    '18:31',
    'VERVOER',
    'Extra pendelbussen vannacht',
    'Vanaf 23:30 rijdt iedere tien minuten een bus naar station Dronten.',
  ),
  NewsItem(
    '17:55',
    'PROGRAMMA',
    'Stagewissel: D-Sturb',
    'D-Sturb speelt om 19:00 op BLUE in plaats van BLACK.',
  ),
  NewsItem(
    '16:20',
    'WEER',
    'Droog en warm tot vanavond',
    'Verwachte temperatuur om 20:00 is 21°C. UV-index neemt af.',
  ),
];
