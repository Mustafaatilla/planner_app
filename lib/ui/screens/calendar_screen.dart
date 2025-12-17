import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../logic/calendar_provider.dart';
import '../../logic/task_provider.dart';
import '../../logic/habit_provider.dart';
import '../../logic/theme_provider.dart';
import '../../core/theme.dart';
import '../widgets/weekly_view_widget.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/general_todo_list.dart';
import 'weekly_review_screen.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calendarProvider = Provider.of<CalendarProvider>(context);
    
    // Calculate the current week's month/year for the title
    final focusedDay = calendarProvider.focusedDay;
    final title = DateFormat('MMMM yyyy').format(focusedDay);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        centerTitle: false,
        title: null,
        actions: [
          // Date Selector (Moved from Title)
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = MediaQuery.of(context).size.width < 600;
              final iconSize = isMobile ? 20.0 : 24.0;
              final textStyle = theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 14 : 16,
              );

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Left Arrow
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: iconSize),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      calendarProvider.setFocusedDay(
                        calendarProvider.focusedDay.subtract(const Duration(days: 7)),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  
                  // Month Selector
                  InkWell(
                    onTap: () => _showMonthPicker(context, calendarProvider),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        DateFormat('MMMM').format(focusedDay),
                        style: textStyle,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 4),

                  // Year Selector
                  InkWell(
                    onTap: () => _showYearPicker(context, calendarProvider),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        DateFormat('yyyy').format(focusedDay),
                        style: textStyle,
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  // Right Arrow
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: iconSize),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      calendarProvider.setFocusedDay(
                        calendarProvider.focusedDay.add(const Duration(days: 7)),
                      );
                    },
                  ),
                  
                  const SizedBox(width: 8), // Spacer between date nav and other actions
                ],
              );
            }
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = MediaQuery.of(context).size.width < 600;
              final iconSize = isMobile ? 20.0 : 24.0;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, size: iconSize),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Add Habit',
                    onPressed: () => _showAddHabitSheet(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.my_location, size: iconSize),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Go to Today',
                    onPressed: () {
                      calendarProvider.setFocusedDay(DateTime.now());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.bar_chart, size: iconSize),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Weekly Review',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WeeklyReviewScreen()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, size: iconSize),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Settings',
                    onPressed: () => _showSettingsDialog(context),
                  ),
                  const SizedBox(width: 8),
                ],
              );
            }
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          
          // Two-mode layout: Desktop or Mobile Grid
          final isDesktop = width > 750;

          // Desktop Mode: Row layout (horizontal split)
          if (isDesktop) {
            return Column(
              children: [
                Divider(height: 1, color: theme.dividerColor),
                Expanded(
                  child: Row(
                    children: [
                      // Left: Weekly Grid
                      Expanded(
                        flex: 5,
                        child: WeeklyViewWidget(
                          focusedDay: calendarProvider.focusedDay,
                          showSideNavigation: true,
                        ),
                      ),
                      // Right: General To-Do
                      VerticalDivider(width: 1, color: theme.dividerColor),
                      const Expanded(
                        flex: 1,
                        child: GeneralTodoList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Mobile/Tablet Mode: 8-tile grid (General To-Do is 8th tile)
          return Column(
            children: [
              Divider(height: 1, color: theme.dividerColor),
              Expanded(
                child: WeeklyViewWidget(
                  focusedDay: calendarProvider.focusedDay,
                  showSideNavigation: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMonthPicker(BuildContext context, CalendarProvider provider) {
    final theme = Theme.of(context);
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Month',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(12, (index) {
                  final isSelected = provider.focusedDay.month == index + 1;
                  return InkWell(
                    onTap: () {
                      final newDate = DateTime(
                        provider.focusedDay.year,
                        index + 1,
                        provider.focusedDay.day,
                      );
                      provider.setFocusedDay(newDate);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
                        ),
                      ),
                      child: Text(
                        months[index],
                        style: TextStyle(
                          color: isSelected ? theme.colorScheme.onPrimary : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context, CalendarProvider provider) {
    final theme = Theme.of(context);
    final currentYear = DateTime.now().year;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        child: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Year',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: YearPicker(
                  firstDate: DateTime(currentYear - 10),
                  lastDate: DateTime(currentYear + 10),
                  selectedDate: provider.focusedDay,
                  onChanged: (DateTime dateTime) {
                    provider.setFocusedDay(dateTime);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCalendarDialog(BuildContext context, CalendarProvider provider) {
    _showMonthPicker(context, provider);
  }

  void _showAddHabitSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddHabitSheet(),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _SettingsDialog(),
    );
  }
}

class _SettingsDialog extends StatelessWidget {
  const _SettingsDialog();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      backgroundColor: Colors.transparent,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              RadioListTile<ThemeType>(
                title: const Text('Light Mode'),
                value: ThemeType.light,
                groupValue: themeProvider.currentTheme,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  if (value != null) themeProvider.setTheme(value);
                  Navigator.pop(context);
                },
              ),

              RadioListTile<ThemeType>(
                title: const Text('Gothic Dark Academia'),
                value: ThemeType.gothicDarkAcademia,
                groupValue: themeProvider.currentTheme,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  if (value != null) themeProvider.setTheme(value);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
