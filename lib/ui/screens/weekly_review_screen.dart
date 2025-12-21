import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/task_provider.dart';
import '../../logic/habit_provider.dart';
import 'package:planner_app/l10n/app_localizations.dart';
import '../../logic/stats_helper.dart';

class WeeklyReviewScreen extends StatelessWidget {
  const WeeklyReviewScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context);

    final now = DateTime.now();
    // Find the start of the week (Monday)
    // Find the start of the week (Monday) at midnight
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59));

    final completionRate = StatsHelper.calculateWeeklyTaskCompletionRate(
        taskProvider.tasks, startOfWeek, endOfWeek);
    final dailyStats = StatsHelper.calculateDailyTaskCompletion(
        taskProvider.tasks, startOfWeek);
    final habitStats = StatsHelper.calculateHabitConsistency(
        habitProvider.habits, startOfWeek, endOfWeek);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.weeklyReview),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: Container(
            width: 380,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${DateFormat('MMMM d').format(startOfWeek)} - ${DateFormat('MMMM d').format(endOfWeek)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Productivity Score Card
                _buildProductivityScore(context, completionRate),
                const SizedBox(height: 40),

                // Daily Breakdown Chart
                Text(AppLocalizations.of(context)!.dailyPerformance, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _buildDailyBreakdownChart(context, dailyStats, startOfWeek),
                const SizedBox(height: 40),

                // Habit Consistency
                if (habitStats.isNotEmpty) ...[
                  Text(AppLocalizations.of(context)!.habitConsistency, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...habitStats.entries.map((entry) {
                    final completed = entry.value['completed']!;
                    final active = entry.value['active']!;
                    final progress = active > 0 ? completed / active : 0.0;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  entry.key,
                                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.daysCount(completed, active),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: theme.colorScheme.surfaceVariant,
                              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductivityScore(BuildContext context, double completionRate) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 12,
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: completionRate),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        value >= 0.8 ? Colors.green : (value >= 0.5 ? Colors.orange : Colors.red),
                      ),
                    );
                  },
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: completionRate),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return Text(
                            '${(value * 100).toInt()}%',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          );
                        },
                      ),
                      Text(
                        AppLocalizations.of(context)!.completion,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyBreakdownChart(BuildContext context, Map<int, double> dailyStats, DateTime startOfWeek) {
    final theme = Theme.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;

    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final dayName = DateFormat('E', localeCode).format(startOfWeek.add(Duration(days: index)));
          final value = dailyStats[index] ?? 0.0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: value),
                duration: Duration(milliseconds: 1000 + (index * 100)),
                curve: Curves.easeOutQuad,
                builder: (context, value, _) {
                  return Container(
                    width: 32,
                    height: 120 * value + 4, // Min height for visibility
                    decoration: BoxDecoration(
                      color: value > 0 
                          ? theme.colorScheme.primary.withOpacity(0.8) 
                          : theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      gradient: value > 0 ? LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.6),
                          theme.colorScheme.primary,
                        ],
                      ) : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                dayName, 
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
