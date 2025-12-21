// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get generalTodo => 'مهام عامة';

  @override
  String get weeklyReview => 'المراجعة الأسبوعية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get theme => 'السمة';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get themeGothic => 'الوضع القوطي المظلم';

  @override
  String get language => 'اللغة';

  @override
  String get close => 'إغلاق';

  @override
  String get addTask => 'إضافة مهمة...';

  @override
  String get confirmCompletion => 'تأكيد الإكمال';

  @override
  String get confirmCompletionMessage => 'هل أكملت هذه المهمة حقًا في الماضي؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get delete => 'حذف';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get getStarted => 'البدء';

  @override
  String get habits => 'عادات';

  @override
  String get addHabit => 'إضافة عادة';

  @override
  String get habitName => 'اسم العادة';

  @override
  String get habitColor => 'لون العادة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get addHabitTooltip => 'إضافة عادة';

  @override
  String get goToTodayTooltip => 'الذهاب إلى اليوم';

  @override
  String get empty => 'فارغ';

  @override
  String get newHabit => 'عادة جديدة';

  @override
  String get habitTitle => 'عنوان العادة';

  @override
  String get habitTitleHint => 'الرجاء إدخال عنوان';

  @override
  String get duration => 'المدة';

  @override
  String get oneWeek => 'أسبوع واحد';

  @override
  String get oneMonth => 'شهر واحد';

  @override
  String get custom => 'مخصص';

  @override
  String get permanent => 'دائم';

  @override
  String get durationDays => 'المدة (أيام)';

  @override
  String get daysSuffix => 'أيام';

  @override
  String get enterDuration => 'الرجاء إدخال المدة';

  @override
  String get validNumber => 'الرجاء إدخال رقم صحيح';

  @override
  String get color => 'اللون';

  @override
  String get dailyPerformance => 'الأداء اليومي';

  @override
  String get habitConsistency => 'اتساق العادة';

  @override
  String get completion => 'إكمال';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active أيام';
  }
}
