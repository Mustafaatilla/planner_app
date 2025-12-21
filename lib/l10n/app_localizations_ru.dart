// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get generalTodo => 'Общие задачи';

  @override
  String get weeklyReview => 'Еженедельный обзор';

  @override
  String get settings => 'Настройки';

  @override
  String get theme => 'Тема';

  @override
  String get lightMode => 'Светлый режим';

  @override
  String get themeGothic => 'Готический темный режим';

  @override
  String get language => 'Язык';

  @override
  String get close => 'Закрыть';

  @override
  String get addTask => 'Добавить задачу...';

  @override
  String get confirmCompletion => 'Подтвердить выполнение';

  @override
  String get confirmCompletionMessage =>
      'Вы действительно выполнили эту задачу в прошлом?';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get delete => 'Удалить';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get getStarted => 'Начать';

  @override
  String get habits => 'Привычки';

  @override
  String get addHabit => 'Добавить привычку';

  @override
  String get habitName => 'Название привычки';

  @override
  String get habitColor => 'Цвет привычки';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get addHabitTooltip => 'Добавить привычку';

  @override
  String get goToTodayTooltip => 'Перейти к сегодня';

  @override
  String get empty => 'Пусто';

  @override
  String get newHabit => 'Новая привычка';

  @override
  String get habitTitle => 'Название привычки';

  @override
  String get habitTitleHint => 'Пожалуйста, введите название';

  @override
  String get duration => 'Длительность';

  @override
  String get oneWeek => '1 Неделя';

  @override
  String get oneMonth => '1 Месяц';

  @override
  String get custom => 'Пользовательский';

  @override
  String get permanent => 'Постоянно';

  @override
  String get durationDays => 'Длительность (Дни)';

  @override
  String get daysSuffix => 'дни';

  @override
  String get enterDuration => 'Пожалуйста, введите длительность';

  @override
  String get validNumber => 'Пожалуйста, введите действительное число';

  @override
  String get color => 'Цвет';

  @override
  String get dailyPerformance => 'Ежедневная производительность';

  @override
  String get habitConsistency => 'Постоянство привычки';

  @override
  String get completion => 'Завершение';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active дни';
  }
}
