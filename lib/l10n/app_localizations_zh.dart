// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get generalTodo => '一般待办事项';

  @override
  String get weeklyReview => '每周回顾';

  @override
  String get settings => '设置';

  @override
  String get theme => '主题';

  @override
  String get lightMode => '浅色模式';

  @override
  String get themeGothic => '哥特暗黑模式';

  @override
  String get language => '语言';

  @override
  String get close => '关闭';

  @override
  String get addTask => '添加任务...';

  @override
  String get confirmCompletion => '确认完成';

  @override
  String get confirmCompletionMessage => '您真的在过去完成了这项任务吗？';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get delete => '删除';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get getStarted => '开始';

  @override
  String get habits => '习惯';

  @override
  String get addHabit => '添加习惯';

  @override
  String get habitName => '习惯名称';

  @override
  String get habitColor => '习惯颜色';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get addHabitTooltip => '添加习惯';

  @override
  String get goToTodayTooltip => '回到今天';

  @override
  String get empty => '空';

  @override
  String get newHabit => '新习惯';

  @override
  String get habitTitle => '习惯标题';

  @override
  String get habitTitleHint => '请输入标题';

  @override
  String get duration => '持续时间';

  @override
  String get oneWeek => '1周';

  @override
  String get oneMonth => '1个月';

  @override
  String get custom => '自定义';

  @override
  String get permanent => '永久';

  @override
  String get durationDays => '持续时间（天）';

  @override
  String get daysSuffix => '天';

  @override
  String get enterDuration => '请输入持续时间';

  @override
  String get validNumber => '请输入有效数字';

  @override
  String get color => '颜色';

  @override
  String get dailyPerformance => '每日表现';

  @override
  String get habitConsistency => '习惯一致性';

  @override
  String get completion => '完成度';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active 天';
  }
}
