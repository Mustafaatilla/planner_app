// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get generalTodo => 'Allgemeine Aufgaben';

  @override
  String get weeklyReview => 'Wochenrückblick';

  @override
  String get settings => 'Einstellungen';

  @override
  String get theme => 'Thema';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get themeGothic => 'Gothic Dark Mode';

  @override
  String get language => 'Sprache';

  @override
  String get close => 'Schließen';

  @override
  String get addTask => 'Aufgabe hinzufügen...';

  @override
  String get confirmCompletion => 'Abschluss bestätigen';

  @override
  String get confirmCompletionMessage =>
      'Haben Sie diese Aufgabe in der Vergangenheit wirklich erledigt?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get delete => 'Löschen';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get habits => 'Gewohnheiten';

  @override
  String get addHabit => 'Gewohnheit hinzufügen';

  @override
  String get habitName => 'Name der Gewohnheit';

  @override
  String get habitColor => 'Farbe der Gewohnheit';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get addHabitTooltip => 'Gewohnheit hinzufügen';

  @override
  String get goToTodayTooltip => 'Gehe zu Heute';

  @override
  String get empty => 'Leer';

  @override
  String get newHabit => 'Neue Gewohnheit';

  @override
  String get habitTitle => 'Titel der Gewohnheit';

  @override
  String get habitTitleHint => 'Bitte geben Sie einen Titel ein';

  @override
  String get duration => 'Dauer';

  @override
  String get oneWeek => '1 Woche';

  @override
  String get oneMonth => '1 Monat';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get permanent => 'Dauerhaft';

  @override
  String get durationDays => 'Dauer (Tage)';

  @override
  String get daysSuffix => 'Tage';

  @override
  String get enterDuration => 'Bitte geben Sie die Dauer ein';

  @override
  String get validNumber => 'Bitte geben Sie eine gültige Zahl ein';

  @override
  String get color => 'Farbe';

  @override
  String get dailyPerformance => 'Tägliche Leistung';

  @override
  String get habitConsistency => 'Gewohnheitskonsistenz';

  @override
  String get completion => 'Abschluss';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active Tage';
  }
}
