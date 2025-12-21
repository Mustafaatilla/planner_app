// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get generalTodo => 'Genel Yapılacaklar';

  @override
  String get weeklyReview => 'Haftalık İnceleme';

  @override
  String get settings => 'Ayarlar';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Açık Mod';

  @override
  String get themeGothic => 'Gotik Karanlık Mod';

  @override
  String get language => 'Dil';

  @override
  String get close => 'Kapat';

  @override
  String get addTask => 'Görev ekle...';

  @override
  String get confirmCompletion => 'Tamamlamayı Onayla';

  @override
  String get confirmCompletionMessage =>
      'Bu görevi geçmişte gerçekten tamamladınız mı?';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get delete => 'Sil';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get getStarted => 'Başla';

  @override
  String get habits => 'Alışkanlıklar';

  @override
  String get addHabit => 'Alışkanlık Ekle';

  @override
  String get habitName => 'Alışkanlık Adı';

  @override
  String get habitColor => 'Alışkanlık Rengi';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get addHabitTooltip => 'Alışkanlık Ekle';

  @override
  String get goToTodayTooltip => 'Bugüne Git';

  @override
  String get empty => 'Boş';

  @override
  String get newHabit => 'Yeni Alışkanlık';

  @override
  String get habitTitle => 'Alışkanlık Başlığı';

  @override
  String get habitTitleHint => 'Lütfen bir başlık girin';

  @override
  String get duration => 'Süre';

  @override
  String get oneWeek => '1 Hafta';

  @override
  String get oneMonth => '1 Ay';

  @override
  String get custom => 'Özel';

  @override
  String get permanent => 'Sürekli';

  @override
  String get durationDays => 'Süre (Gün)';

  @override
  String get daysSuffix => 'gün';

  @override
  String get enterDuration => 'Lütfen süre girin';

  @override
  String get validNumber => 'Geçerli bir sayı girin';

  @override
  String get color => 'Renk';

  @override
  String get dailyPerformance => 'Günlük Performans';

  @override
  String get habitConsistency => 'Alışkanlık Tutarlılığı';

  @override
  String get completion => 'Tamamlanma';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active gün';
  }
}
