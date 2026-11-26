import 'package:shared_preferences/shared_preferences.dart';

/// Alle aan/uit-instellingen van de app op één plek.
/// Ze worden op de telefoon bewaard, dus na het afsluiten weet de app ze nog.
class Instellingen {
  Instellingen._();

  /// De standaardwaarden (true = aan).
  static final Map<String, bool> waarden = {
    // Profielmenu
    'Meldingen': true,
    'Locatie delen met squad': true,
    'Offline festivaldata': false,
    // Bel-knop bij NIEUWS
    'BELANGRIJK': true,
    'PROGRAMMA': true,
    'VERVOER': true,
    'WEER': false,
    'VEILIGHEID': true,
    'ALGEMEEN': false,
    'ARTIESTEN': true,
  };

  /// Haal de bewaarde keuzes op (één keer, bij het starten van de app).
  static Future<void> laad() async {
    final prefs = await SharedPreferences.getInstance();
    for (final naam in waarden.keys) {
      waarden[naam] = prefs.getBool('inst-$naam') ?? waarden[naam]!;
    }
    bewaard.addAll(prefs.getStringList('bewaard') ?? []);
    herinneringen.addAll(prefs.getStringList('herinneringen') ?? []);
  }

  /// Acts die je met het hartje hebt bewaard (MIJN SCHEMA).
  /// We bewaren 'DAG|TIJD|ARTIEST', want één artiest kan vaker spelen.
  static final Set<String> bewaard = {};

  /// Hartje aan of uit zetten en bewaren.
  static Future<void> wisselBewaard(String sleutel) async {
    if (!bewaard.remove(sleutel)) bewaard.add(sleutel);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bewaard', bewaard.toList());
  }

  /// Optredens waarvoor je een herinnering hebt aangezet (zelfde sleutel als het hartje).
  static final Set<String> herinneringen = {};

  /// Herinnering aan of uit zetten en bewaren.
  static Future<void> wisselHerinnering(String sleutel) async {
    if (!herinneringen.remove(sleutel)) herinneringen.add(sleutel);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('herinneringen', herinneringen.toList());
  }

  /// Is deze instelling aan?
  static bool aan(String naam) => waarden[naam] ?? false;

  /// Zet een instelling aan of uit en bewaar het.
  static Future<void> zet(String naam, bool waarde) async {
    waarden[naam] = waarde;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('inst-$naam', waarde);
  }
}
