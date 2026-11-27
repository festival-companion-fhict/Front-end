import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// De taal van de app: 'nl' (Nederlands) of 'en' (Engels).
class Taal {
  Taal._();

  /// De huidige taal. Verandert hij, dan tekent de app zich opnieuw (zie main.dart).
  static final ValueNotifier<String> huidig = ValueNotifier('nl');

  static bool get engels => huidig.value == 'en';

  /// Bij het opstarten: bewaarde keuze ophalen, anders de taal van de telefoon.
  static Future<void> laad() async {
    final prefs = await SharedPreferences.getInstance();
    final telefoon = PlatformDispatcher.instance.locale.languageCode;
    huidig.value = prefs.getString('taal') ?? (telefoon == 'nl' ? 'nl' : 'en');
  }

  /// Andere taal kiezen en bewaren.
  static Future<void> zet(String code) async {
    huidig.value = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('taal', code);
  }
}

/// Vertaal een tekst. Je geeft altijd de Nederlandse tekst mee.
/// Staat de app op Engels en is er een vertaling? Dan krijg je die terug.
/// Anders gewoon de Nederlandse tekst (er gaat dus nooit iets kapot).
String t(String nl) => Taal.engels ? (_engels[nl] ?? nl) : nl;

/// Het woordenboek: Nederlands → Engels.
/// Slogans (CHOOSE YOUR BATTLES, WARRIORS ...) staan er niet in: die blijven Engels.
/// Databasewaarden (AFVAL, PROGRAMMA ...) staan er wel in, maar alleen om te TONEN.
const _engels = <String, String>{
  // Menubalk en algemeen
  'HOME': 'HOME',
  'KAART': 'MAP',
  'SCHEMA': 'LINE-UP',
  'MELDEN': 'REPORT',
  'NIEUWS': 'NEWS',
  'SQUAD': 'SQUAD',
  'LIVE UPDATE': 'LIVE UPDATE',
  'ZEER DRUK': 'VERY BUSY',
  'RED: ZEER DRUK': 'RED: VERY BUSY',
  'TOON OP KAART': 'SHOW ON MAP',
  'OP KAART': 'ON MAP',
  'KLAAR': 'DONE',
  'OKÉ': 'OK',
  'NU': 'NOW',
  'ROUTE': 'ROUTE',

  // Startscherm
  'Alles wat je vandaag nodig hebt. Live schema, drukte, routes, waarschuwingen en je crew.': 'Everything you need today. Live line-up, crowds, routes, alerts and your crew.',
  'TERREIN OPEN': 'GROUNDS OPEN',
  'Updates zijn live': 'Updates are live',
  'Droog tot 23:00': 'Dry until 23:00',
  'BEKIJK STAGES': 'VIEW STAGES',
  'NAAR HET FESTIVAL': 'ENTER THE FESTIVAL',

  // HOME
  'JE BENT NU BIJ': 'YOU ARE AT',
  'WIJZIG': 'CHANGE',
  'LIVE NU': 'LIVE NOW',
  '10 MIN VERTRAAGD': '10 MIN DELAYED',
  'MIN NOG': 'MIN LEFT',
  'DRUKTE': 'CROWDS',
  '92% capaciteit': '92% capacity',
  'GELUID': 'SOUND',
  'Oordoppen aangeraden': 'Earplugs advised',
  'HIERNA · 19:10': 'UP NEXT · 19:10',
  'Begint over 28 minuten': 'Starts in 28 minutes',
  'VLAKBIJ JOU': 'NEAR YOU',
  '1 min · rustig': '1 min · quiet',
  '2 min · druk': '2 min · busy',
  '3 min · open': '3 min · open',
  'EHBO': 'MEDIC',
  'UITGANG LINKS TIJDELIJK DRUK': 'LEFT EXIT TEMPORARILY BUSY',
  'Gebruik na de show bij voorkeur de uitgang aan de rechterkant.':
      'After the show, please use the exit on the right.',
  'GELUID · 102 DB': 'SOUND · 102 DB',
  'BESCHERM JE OREN': 'PROTECT YOUR EARS',
  'Boven 100 dB kan je gehoor al na korte tijd beschadigen. ':
      'Above 100 dB your hearing can be damaged quickly. ',
  'Gratis oordoppen haal je bij elke EHBO-post en bij de bars.':
      'Get free earplugs at every first aid post and at the bars.',

  // SCHEMA
  'MIJN SCHEMA': 'MY LINE-UP',
  'JUNI': 'JUNE',
  'STAGE': 'STAGE',
  'GENRE': 'GENRE',
  'ALLE STAGES': 'ALL STAGES',
  'ALLE GENRES': 'ALL GENRES',
  'KIES EEN STAGE': 'PICK A STAGE',
  'KIES JE SOUND': 'PICK YOUR SOUND',
  'OVERIG': 'OTHER',
  'Zoek artiest, stage of genre…': 'Search artist, stage or genre…',
  'LIVE NU · 10 MIN VERTRAAGD': 'LIVE NOW · 10 MIN DELAYED',
  'Geen acts gevonden. Kies een andere dag, stage of genre.':
      'No acts found. Pick another day, stage or genre.',
  'Nog niets bewaard. Tik op het hartje bij een act om hem aan MIJN SCHEMA toe te voegen.':
      'Nothing saved yet. Tap the heart on an act to add it to MY LINE-UP.',

  // ARTIEST
  'WANNEER': 'WHEN',
  'WAAR': 'WHERE',
  'INFO': 'INFO',
  'OPTREDENS': 'SHOWS',
  'HERINNER ME 15 MIN VAN TEVOREN': 'REMIND ME 15 MIN BEFORE',

  // NIEUWS
  'LIVE NIEUWS': 'LIVE NEWS',
  'LAATST BIJGEWERKT · NU': 'LAST UPDATED · NOW',
  'BELANGRIJK': 'IMPORTANT',
  'ALLES': 'ALL',
  'PROGRAMMA': 'PROGRAMME',
  'VERVOER': 'TRANSPORT',
  'WEER': 'WEATHER',
  'VEILIGHEID': 'SAFETY',
  'ALGEMEEN': 'GENERAL',
  'ARTIESTEN': 'ARTISTS',
  'EXTRA WATERPUNTEN OPEN': 'EXTRA WATER POINTS OPEN',
  'Door de warmte zijn extra tappunten geopend naast RED en BLUE. Drink voldoende.': 'Because of the heat, extra water taps are open next to RED and BLUE. Drink enough.',
  'POWER HOUR IS 10 MIN VERTRAAGD': 'POWER HOUR IS 10 MIN DELAYED',
  'PUSHBERICHTEN': 'PUSH NOTIFICATIONS',
  'MELDINGEN': 'NOTIFICATIONS',
  'Kies over welk nieuws je een melding op je telefoon wilt krijgen.':
      'Choose which news you want to get a notification about.',
  'VANDAAG': 'TODAY',
  'TERUG NAAR NIEUWS': 'BACK TO NEWS',

  // MELDEN
  'GEEN DIRECT GEVAAR?': 'NO DIRECT DANGER?',
  'Voor direct gevaar gebruik je altijd de rode SOS-knop. Deze melding gaat naar het terreinteam.': 'For direct danger always use the red SOS button. This report goes to the site team.',
  'WAT WIL JE MELDEN?': 'WHAT DO YOU WANT TO REPORT?',
  'WAT IS ER AAN DE HAND?': "WHAT'S GOING ON?",
  'WAAR IS HET?': 'WHERE IS IT?',
  'AFVAL': 'LITTER',
  'TOILET': 'TOILET',
  'KAPOT': 'BROKEN',
  'LEKKAGE': 'LEAK',
  'VERLOREN': 'LOST',
  'Prullenbak vol': 'Bin full',
  'Afval op de grond': 'Litter on the ground',
  'Glas op de grond': 'Glass on the ground',
  'Geen wc-papier': 'No toilet paper',
  'Verstopt': 'Blocked',
  'Vies': 'Dirty',
  'Deur kapot': 'Door broken',
  'Lamp kapot': 'Light broken',
  'Hek kapot': 'Fence broken',
  'Kraan kapot': 'Tap broken',
  'Lekt': 'Leaking',
  'Plas op de grond': 'Puddle on the ground',
  'Geen water': 'No water',
  'Telefoon': 'Phone',
  'Portemonnee': 'Wallet',
  'Sleutels': 'Keys',
  'Tas': 'Bag',
  'Te druk': 'Too crowded',
  'Gladde vloer': 'Slippery floor',
  'Te donker': 'Too dark',
  'Bijvoorbeeld: de watertap naast RED Stage lekt...':
      'For example: the water tap next to RED Stage is leaking...',
  'FOTO TOEVOEGEN': 'ADD PHOTO',
  '(optioneel)': '(optional)',
  'FOTO TOEGEVOEGD': 'PHOTO ADDED',
  'LIVE LOCATIE TOEVOEGEN': 'ADD LIVE LOCATION',
  'Bij RED Stage · nauwkeurig tot 8 meter':
      'At RED Stage · accurate to 8 metres',
  'VERSTUUR ANONIEM': 'SEND ANONYMOUSLY',
  ' · je locatie is anoniem meegestuurd':
      ' · your location was sent anonymously',
  'Het terreinteam pakt het op.': 'The site team is on it.',
  'ONTVANGEN': 'RECEIVED',
  'IN BEHANDELING': 'IN PROGRESS',
  'AFGEHANDELD': 'RESOLVED',
  'verwacht binnen 10 min': 'expected within 10 min',
  'je krijgt een melding': "you'll get a notification",
  'NIEUWE MELDING': 'NEW REPORT',

  // SQUAD
  'SQUAD CODE': 'SQUAD CODE',
  'DELEN': 'SHARE',
  'Squad-code gekopieerd!': 'Squad code copied!',
  'VOLGENDE AFSPRAAK': 'NEXT MEET-UP',
  'POWER HOUR · 4 WARRIORS GAAN': 'POWER HOUR · 4 WARRIORS GOING',
  'LIVE LOCATIES': 'LIVE LOCATIONS',
  'NIEUWE WARRIOR': 'NEW WARRIOR',
  'VRIEND TOEVOEGEN': 'ADD FRIEND',
  'Vraag je vriend om zijn of haar squad-code (staat in MY SQUAD) en typ hem hieronder.': 'Ask your friend for their squad code (it is in MY SQUAD) and type it below.',
  'BIJV. B7U-114': 'E.G. B7U-114',
  'TOEVOEGEN': 'ADD',
  'LOCATIE': 'LOCATION',
  'VERBORGEN': 'HIDDEN',
  'LAATST GEZIEN': 'LAST SEEN',
  'STUUR PING': 'SEND PING',

  // PROFIEL
  'TOEGANG': 'ACCESS',
  'OPEN MIJN TICKET': 'OPEN MY TICKET',
  'Taal': 'Language',
  'Meldingen': 'Notifications',
  'Locatie delen met squad': 'Share location with squad',
  'Offline festivaldata': 'Offline festival data',

  // SOS
  'Levensgevaarlijk? ': 'Life-threatening? ',
  'Bel eerst zelf 112. Gebruik daarna SOS, zodat het team op het terrein weet waar je bent.': 'Call 112 yourself first. Then use SOS so the team on site knows where you are.',
  'NOODSIGNAAL': 'EMERGENCY SIGNAL',
  'WAAR HEB JE\nHULP BIJ?': 'WHAT DO\nYOU NEED?',
  'Je locatie wordt direct naar het hulpteam gestuurd.':
      'Your location will be sent directly to the response team.',
  'MEDISCH': 'MEDICAL',
  'EHBO-TEAM': 'FIRST AID TEAM',
  'BEVEILIGING': 'SECURITY',
  'VEILIGHEIDSTEAM': 'SAFETY TEAM',
  'SIGNAAL ONTVANGEN': 'SIGNAL RECEIVED',
  'HULP IS\nONDERWEG': 'HELP IS\nON THE WAY',
  'Blijf waar je bent als dat veilig is. Je live locatie is gedeeld.':
      'Stay where you are if it is safe. Your live location has been shared.',
  'VERWACHTE AANKOMST': 'ESTIMATED ARRIVAL',
  'BEGREPEN': 'UNDERSTOOD',
  // Laden en meldingen
  'De line-up wordt nog geladen.': 'The line-up is still loading.',
  'Deze artiest staat niet in de line-up.':
      'This artist is not in the line-up.',
  'Selecteer eerst een artiest uit de line-up.':
      'Pick an artist from the line-up first.',
  'Line-up laden mislukt:': 'Loading the line-up failed:',
  'Er staan geen optredens in de database.':
      'There are no shows in the database.',
  'Line-up laden...': 'Loading line-up...',
  'OPNIEUW PROBEREN': 'TRY AGAIN',
  'Uitnodiging verstuurd naar': 'Invite sent to',
  'Ping verstuurd naar': 'Ping sent to',
  'Nog geen nieuws over': 'No news yet about',
  'MELDING': 'REPORT',
  // Weer
  'Droog tot': 'Dry until',
  'Kans op regen': 'Chance of rain',
  'Droog de komende uren': 'Dry for the next hours',
  'Weer laden...': 'Loading weather...',
};