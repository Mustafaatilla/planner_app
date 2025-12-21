// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get generalTodo => 'सामान्य कार्य';

  @override
  String get weeklyReview => 'साप्ताहिक समीक्षा';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get theme => 'थीम';

  @override
  String get lightMode => 'लाइट मोड';

  @override
  String get themeGothic => 'गोथिक डार्क मोड';

  @override
  String get language => 'भाषा';

  @override
  String get close => 'बंद करें';

  @override
  String get addTask => 'कार्य जोड़ें...';

  @override
  String get confirmCompletion => 'पूर्णता की पुष्टि करें';

  @override
  String get confirmCompletionMessage =>
      'क्या आपने वास्तव में अतीत में यह कार्य पूरा किया था?';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get delete => 'हटाएं';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get habits => 'आदतें';

  @override
  String get addHabit => 'आदत जोड़ें';

  @override
  String get habitName => 'आदत का नाम';

  @override
  String get habitColor => 'आदत का रंग';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get addHabitTooltip => 'आदत जोड़ें';

  @override
  String get goToTodayTooltip => 'आज पर जाएं';

  @override
  String get empty => 'खाली';

  @override
  String get newHabit => 'नई आदत';

  @override
  String get habitTitle => 'आदत का शीर्षक';

  @override
  String get habitTitleHint => 'कृपया एक शीर्षक दर्ज करें';

  @override
  String get duration => 'अवधि';

  @override
  String get oneWeek => '1 सप्ताह';

  @override
  String get oneMonth => '1 महीना';

  @override
  String get custom => 'कस्टम';

  @override
  String get permanent => 'स्थायी';

  @override
  String get durationDays => 'अवधि (दिन)';

  @override
  String get daysSuffix => 'दिन';

  @override
  String get enterDuration => 'कृपया अवधि दर्ज करें';

  @override
  String get validNumber => 'कृपया एक मान्य संख्या दर्ज करें';

  @override
  String get color => 'रंग';

  @override
  String get dailyPerformance => 'दैनिक प्रदर्शन';

  @override
  String get habitConsistency => 'आदत स्थिरता';

  @override
  String get completion => 'पूर्णता';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active दिन';
  }
}
