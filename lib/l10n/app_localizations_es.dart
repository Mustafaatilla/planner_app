// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get generalTodo => 'Tareas Generales';

  @override
  String get weeklyReview => 'Revisión Semanal';

  @override
  String get settings => 'Ajustes';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get themeGothic => 'Modo Oscuro Gótico';

  @override
  String get language => 'Idioma';

  @override
  String get close => 'Cerrar';

  @override
  String get addTask => 'Añadir tarea...';

  @override
  String get confirmCompletion => 'Confirmar finalización';

  @override
  String get confirmCompletionMessage =>
      '¿Realmente completaste esta tarea en el pasado?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get delete => 'Eliminar';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get getStarted => 'Empezar';

  @override
  String get habits => 'Hábitos';

  @override
  String get addHabit => 'Añadir Hábito';

  @override
  String get habitName => 'Nombre del Hábito';

  @override
  String get habitColor => 'Color del Hábito';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get addHabitTooltip => 'Añadir Hábito';

  @override
  String get goToTodayTooltip => 'Ir a Hoy';

  @override
  String get empty => 'Vacío';

  @override
  String get newHabit => 'Nuevo Hábito';

  @override
  String get habitTitle => 'Título del Hábito';

  @override
  String get habitTitleHint => 'Por favor, introduzca un título';

  @override
  String get duration => 'Duración';

  @override
  String get oneWeek => '1 Semana';

  @override
  String get oneMonth => '1 Mes';

  @override
  String get custom => 'Personalizado';

  @override
  String get permanent => 'Permanente';

  @override
  String get durationDays => 'Duración (Días)';

  @override
  String get daysSuffix => 'días';

  @override
  String get enterDuration => 'Por favor, introduzca la duración';

  @override
  String get validNumber => 'Por favor, introduzca un número válido';

  @override
  String get color => 'Color';

  @override
  String get dailyPerformance => 'Rendimiento Diario';

  @override
  String get habitConsistency => 'Consistencia de Hábitos';

  @override
  String get completion => 'Finalización';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active días';
  }
}
