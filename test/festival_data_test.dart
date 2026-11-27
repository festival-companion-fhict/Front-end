import 'package:defqon_app/data/festival_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('combines database records, removes duplicates and sorts by start', () {
    final optredens = [
      {
        'artiest_id': 2,
        'podium_id': 3,
        'starttijd': '2025-06-26T19:00:00.000Z',
        'eindtijd': '2025-06-26T20:00:00.000Z',
        'artiest_naam': 'Angerfist',
        'podium_naam': 'BLACK',
      },
      {
        'artiest_id': 2,
        'podium_id': 6,
        'starttijd': '2025-06-26T19:00:00.000Z',
        'eindtijd': '2025-06-26T20:00:00.000Z',
        'artiest_naam': 'Angerfist',
        'podium_naam': 'GREEN',
      },
      {
        'artiest_id': 2,
        'podium_id': 3,
        'starttijd': '2025-06-26T19:00:00.000Z',
        'eindtijd': '2025-06-26T20:00:00.000Z',
        'artiest_naam': 'Angerfist',
        'podium_naam': 'BLACK',
      },
      {
        'artiest_id': 4,
        'podium_id': 1,
        'starttijd': '2025-06-26T18:00:00.000Z',
        'eindtijd': '2025-06-26T19:00:00.000Z',
        'artiest_naam': 'Sefa',
        'podium_naam': 'RED',
      },
    ];
    final artiesten = [
      {
        'id': 2,
        'genre': 'hardcore',
        'omschrijving': 'Een artiestomschrijving.',
      },
      {'id': 4, 'genre': 'HARDSTYLE', 'omschrijving': ''},
    ];

    final acts = parseLineupData(optredens, artiesten);

    expect(acts, hasLength(3));
    expect(acts.first.artist, 'SEFA');
    expect(acts.first.dag, 'THU 26');
    expect(acts.first.time, '18:00');
    expect(acts.first.stage, 'RED');
    expect(acts.first.genre, 'HARDSTYLE');
    expect(acts.last.artist, 'ANGERFIST');
    expect(acts.last.genre, 'HARDCORE');
    expect(acts.last.info, 'Een artiestomschrijving.');
    expect(acts[1].stage, 'BLACK');
    expect(acts[2].stage, 'GREEN');
  });

  test('uses OVERIG when an act has no genre record', () {
    final acts = parseLineupData([
      {
        'artiest_id': 1,
        'podium_id': 1,
        'starttijd': '2025-06-26T18:00:00.000Z',
        'eindtijd': '2025-06-26T19:00:00.000Z',
        'artiest_naam': 'Unknown',
        'podium_naam': 'RED',
      },
    ], []);

    expect(acts.single.genre, 'OVERIG');
  });
}
