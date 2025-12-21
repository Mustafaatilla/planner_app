// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get generalTodo => 'Tarefas Gerais';

  @override
  String get weeklyReview => 'Revisão Semanal';

  @override
  String get settings => 'Configurações';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get themeGothic => 'Modo Escuro Gótico';

  @override
  String get language => 'Idioma';

  @override
  String get close => 'Fechar';

  @override
  String get addTask => 'Adicionar tarefa...';

  @override
  String get confirmCompletion => 'Confirmar Conclusão';

  @override
  String get confirmCompletionMessage =>
      'Você realmente completou esta tarefa no passado?';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get delete => 'Excluir';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get getStarted => 'Começar';

  @override
  String get habits => 'Hábitos';

  @override
  String get addHabit => 'Adicionar Hábito';

  @override
  String get habitName => 'Nome do Hábito';

  @override
  String get habitColor => 'Cor do Hábito';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get addHabitTooltip => 'Adicionar Hábito';

  @override
  String get goToTodayTooltip => 'Ir para Hoje';

  @override
  String get empty => 'Vazio';

  @override
  String get newHabit => 'Novo Hábito';

  @override
  String get habitTitle => 'Título do Hábito';

  @override
  String get habitTitleHint => 'Por favor, insira um título';

  @override
  String get duration => 'Duração';

  @override
  String get oneWeek => '1 Semana';

  @override
  String get oneMonth => '1 Mês';

  @override
  String get custom => 'Personalizado';

  @override
  String get permanent => 'Permanente';

  @override
  String get durationDays => 'Duração (Dias)';

  @override
  String get daysSuffix => 'dias';

  @override
  String get enterDuration => 'Por favor, insira a duração';

  @override
  String get validNumber => 'Por favor, insira um número válido';

  @override
  String get color => 'Cor';

  @override
  String get dailyPerformance => 'Desempenho Diário';

  @override
  String get habitConsistency => 'Consistência do Hábito';

  @override
  String get completion => 'Conclusão';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active dias';
  }
}
