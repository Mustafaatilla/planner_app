import '../data/models/task_model.dart';
import '../data/models/habit_model.dart';

class StatsHelper {
  static double calculateWeeklyTaskCompletionRate(
      List<Task> allTasks, DateTime startOfWeek, DateTime endOfWeek) {
    final weeklyTasks = allTasks.where((task) {
      if (task.date == null) return false;
      return task.date!.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          task.date!.isBefore(endOfWeek.add(const Duration(seconds: 1)));
    }).toList();

    if (weeklyTasks.isEmpty) return 0.0;

    final completedCount = weeklyTasks.where((t) => t.isCompleted).length;
    return completedCount / weeklyTasks.length;
  }

  static Map<int, double> calculateDailyTaskCompletion(
      List<Task> allTasks, DateTime startOfWeek) {
    Map<int, double> dailyStats = {};

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayTasks = allTasks.where((t) =>
          t.date != null &&
          t.date!.year == day.year &&
          t.date!.month == day.month &&
          t.date!.day == day.day).toList();

      if (dayTasks.isEmpty) {
        dailyStats[i] = 0.0;
      } else {
        final completed = dayTasks.where((t) => t.isCompleted).length;
        dailyStats[i] = completed / dayTasks.length;
      }
    }
    return dailyStats;
  }

  static Map<String, Map<String, int>> calculateHabitConsistency(
      List<Habit> habits, DateTime startOfWeek, DateTime endOfWeek) {
    Map<String, Map<String, int>> habitStats = {};

    for (var habit in habits) {
      int activeCount = 0;
      int completedCount = 0;

      // Iterate through each day of the week
      for (int i = 0; i < 7; i++) {
        final day = startOfWeek.add(Duration(days: i));
        
        // Check if habit is active on this day
        if (habit.isActiveOn(day)) {
          activeCount++;
          
          // Check if completed on this day
          if (habit.isCompletedOn(day)) {
            completedCount++;
          }
        }
      }
      
      // Only add to stats if it was active at least once this week
      if (activeCount > 0) {
        habitStats[habit.title] = {
          'completed': completedCount,
          'active': activeCount,
        };
      }
    }
    return habitStats;
  }
}
