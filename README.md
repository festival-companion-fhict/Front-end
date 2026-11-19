# DEFQON.1 Companion – Flutter-app

Gemaakt van Emi's Figma-ontwerp "defcon festival".

## Starten in VS Code

1. Pak de zip uit en open de map `defqon_app` in VS Code (**File → Open Folder**).
2. Installeer de extensies **Flutter** en **Dart** als je die nog niet hebt.
3. Open een terminal in VS Code (**Terminal → New Terminal**) en typ:
   ```
   flutter pub get
   ```
4. Kies rechtsonder een apparaat (Chrome, een Android-emulator of je telefoon) en druk op **F5**.
   Of typ in de terminal: `flutter run`

## Waar staat wat?

| Map / bestand | Wat zit erin |
|---|---|
| `lib/main.dart` | Start van de app |
| `lib/app_shell.dart` | Header, menubalk, SOS-knop en wisselen tussen schermen |
| `lib/theme/dq_theme.dart` | **Alle kleuren en lettertypes**: hier pas je de stijl aan |
| `lib/data/festival_data.dart` | Line-up, crew en nieuws (voorbeelddata) |
| `lib/screens/` | Eén bestand per scherm |
| `lib/widgets/` | Herbruikbare onderdelen (knoppen, logo, menubalk...) |
| `assets/` | Foto's en lettertypes (Barlow Condensed + Inter) |

## Schermen

Start · Home · Map · Line-up · Artiest · SOS · Melden · Nieuws · Crew · Profiel · Ticket

Tip: het startscherm zie je maar één keer. Wil je het opnieuw zien? Verwijder de app
van je telefoon/emulator, of in Chrome: wis de sitegegevens.
