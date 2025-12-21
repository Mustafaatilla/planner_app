// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get generalTodo => 'General To-Do';

  @override
  String get weeklyReview => 'Weekly Review';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get themeGothic => 'Gothic Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get close => 'Close';

  @override
  String get addTask => 'Add a task...';

  @override
  String get confirmCompletion => 'Confirm Completion';

  @override
  String get confirmCompletionMessage =>
      'Did you really complete this task in the past?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get delete => 'Delete';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get getStarted => 'Get Started';

  @override
  String get habits => 'Habits';

  @override
  String get addHabit => 'Add Habit';

  @override
  String get habitName => 'Habit Name';

  @override
  String get habitColor => 'Habit Color';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get addHabitTooltip => 'Add Habit';

  @override
  String get goToTodayTooltip => 'Go to Today';

  @override
  String get empty => 'Empty';

  @override
  String get newHabit => 'New Habit';

  @override
  String get habitTitle => 'Habit Title';

  @override
  String get habitTitleHint => 'Please enter a title';

  @override
  String get duration => 'Duration';

  @override
  String get oneWeek => '1 Week';

  @override
  String get oneMonth => '1 Month';

  @override
  String get custom => 'Custom';

  @override
  String get permanent => 'Permanent';

  @override
  String get durationDays => 'Duration (Days)';

  @override
  String get daysSuffix => 'days';

  @override
  String get enterDuration => 'Please enter duration';

  @override
  String get validNumber => 'Please enter a valid number';

  @override
  String get color => 'Color';

  @override
  String get dailyPerformance => 'Daily Performance';

  @override
  String get habitConsistency => 'Habit Consistency';

  @override
  String get completion => 'Completion';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active days';
  }
}
