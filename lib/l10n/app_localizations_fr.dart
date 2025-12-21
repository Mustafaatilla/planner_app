// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get generalTodo => 'Tâches Générales';

  @override
  String get weeklyReview => 'Revue Hebdomadaire';

  @override
  String get settings => 'Paramètres';

  @override
  String get theme => 'Thème';

  @override
  String get lightMode => 'Mode Clair';

  @override
  String get themeGothic => 'Mode Sombre Gothique';

  @override
  String get language => 'Langue';

  @override
  String get close => 'Fermer';

  @override
  String get addTask => 'Ajouter une tâche...';

  @override
  String get confirmCompletion => 'Confirmer l\'achèvement';

  @override
  String get confirmCompletionMessage =>
      'Avez-vous vraiment terminé cette tâche dans le passé ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get delete => 'Supprimer';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get getStarted => 'Commencer';

  @override
  String get habits => 'Habitudes';

  @override
  String get addHabit => 'Ajouter une habitude';

  @override
  String get habitName => 'Nom de l\'habitude';

  @override
  String get habitColor => 'Couleur de l\'habitude';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get addHabitTooltip => 'Ajouter une habitude';

  @override
  String get goToTodayTooltip => 'Aller à aujourd\'hui';

  @override
  String get empty => 'Vide';

  @override
  String get newHabit => 'Nouvelle Habitude';

  @override
  String get habitTitle => 'Titre de l\'habitude';

  @override
  String get habitTitleHint => 'Veuillez entrer un titre';

  @override
  String get duration => 'Durée';

  @override
  String get oneWeek => '1 Semaine';

  @override
  String get oneMonth => '1 Mois';

  @override
  String get custom => 'Personnalisé';

  @override
  String get permanent => 'Permanent';

  @override
  String get durationDays => 'Durée (Jours)';

  @override
  String get daysSuffix => 'jours';

  @override
  String get enterDuration => 'Veuillez entrer la durée';

  @override
  String get validNumber => 'Veuillez entrer un nombre valide';

  @override
  String get color => 'Couleur';

  @override
  String get dailyPerformance => 'Performance Quotidienne';

  @override
  String get habitConsistency => 'Cohérence des Habitudes';

  @override
  String get completion => 'Achèvement';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active jours';
  }
}
