import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../logic/calendar_provider.dart';
import '../../logic/task_provider.dart';
import '../../logic/habit_provider.dart';
import '../../logic/theme_provider.dart';
import 'package:planner_app/l10n/app_localizations.dart';
import '../../logic/locale_provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    // Calculate the current week's month/year for the title
    final localeCode = Provider.of<LocaleProvider>(context).locale?.languageCode ?? 'en';
    
    // Calculate the current week's month/year for the title
    final focusedDay = calendarProvider.focusedDay;
    final title = DateFormat('MMMM yyyy', localeCode).format(focusedDay);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: themeProvider.currentTheme == ThemeType.light
            ? Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/textures/watercolor_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : null,
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = MediaQuery.of(context).size.width < 600;
            final iconSize = isMobile ? 20.0 : 24.0;
            final textStyle = theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 16 : 20,
              color: themeProvider.currentTheme == ThemeType.light 
                  ? const Color(0xFF5A463F) 
                  : null,
            );

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Left Arrow
                IconButton(
                  icon: Icon(Icons.chevron_left, size: iconSize),
                  color: themeProvider.currentTheme == ThemeType.light 
                      ? const Color(0xFF5A463F) 
                      : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    calendarProvider.setFocusedDay(
                      calendarProvider.focusedDay.subtract(const Duration(days: 7)),
                    );
                  },
                ),
                const SizedBox(width: 8),
                
                // Month Selector
                InkWell(
                  onTap: () => _showMonthPicker(context, calendarProvider),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Text(
                      DateFormat('MMMM', localeCode).format(focusedDay),
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
                      DateFormat('yyyy', localeCode).format(focusedDay),
                      style: textStyle,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Right Arrow
                IconButton(
                  icon: Icon(Icons.chevron_right, size: iconSize),
                  color: themeProvider.currentTheme == ThemeType.light 
                      ? const Color(0xFF5A463F) 
                      : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    calendarProvider.setFocusedDay(
                      calendarProvider.focusedDay.add(const Duration(days: 7)),
                    );
                  },
                ),
              ],
            );
          }
        ),
        actions: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = MediaQuery.of(context).size.width < 600;
              final iconSize = isMobile ? 20.0 : 24.0;
              final iconColor = themeProvider.currentTheme == ThemeType.light 
                  ? const Color(0xFF5A463F) 
                  : null;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, size: iconSize),
                    color: iconColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: AppLocalizations.of(context)!.addHabitTooltip,
                    onPressed: () => _showAddHabitSheet(context),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.my_location, size: iconSize),
                    color: iconColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: AppLocalizations.of(context)!.goToTodayTooltip,
                    onPressed: () {
                      calendarProvider.setFocusedDay(DateTime.now());
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.bar_chart, size: iconSize),
                    color: iconColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: AppLocalizations.of(context)!.weeklyReview,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WeeklyReviewScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.settings, size: iconSize),
                    color: iconColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: AppLocalizations.of(context)!.settings,
                    onPressed: () => _showSettingsDialog(context),
                  ),
                  const SizedBox(width: 16),
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isLight = themeProvider.currentTheme == ThemeType.light;
    
    final localeCode = Provider.of<LocaleProvider>(context, listen: false).locale?.languageCode ?? 'en';
    
    // Floral Theme Colors
    final floralPrimary = const Color(0xFF5A463F); // Brownish text
    final floralAccent = const Color(0xFFE6CFCF); // Soft pink selection
    
    final months = List.generate(12, (index) => DateFormat('MMMM', localeCode).format(DateTime(2024, index + 1)));

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isLight ? const Color(0xFFFFF8F0) : theme.dialogBackgroundColor, // Warm white for floral
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Month',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isLight ? floralPrimary : null,
                  fontWeight: FontWeight.bold,
                  fontFamily: isLight ? 'Poppins' : null,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 240, // Fixed height for grid
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
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
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? (isLight ? floralAccent : theme.colorScheme.primary) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? (isLight ? floralPrimary : theme.colorScheme.primary) 
                                : (isLight ? floralPrimary.withOpacity(0.2) : theme.dividerColor),
                          ),
                        ),
                        child: Text(
                          months[index],
                          style: TextStyle(
                            color: isSelected 
                                ? (isLight ? floralPrimary : theme.colorScheme.onPrimary) 
                                : (isLight ? floralPrimary : theme.textTheme.bodyMedium?.color),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context, CalendarProvider provider) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isLight = themeProvider.currentTheme == ThemeType.light;
    
    // Floral Theme Colors
    final floralPrimary = const Color(0xFF5A463F);
    final floralAccent = const Color(0xFFE6CFCF);

    final currentYear = DateTime.now().year;
    final startYear = currentYear - 10;
    final years = List.generate(20, (index) => startYear + index);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isLight ? const Color(0xFFFFF8F0) : theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Year',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isLight ? floralPrimary : null,
                  fontWeight: FontWeight.bold,
                  fontFamily: isLight ? 'Poppins' : null,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 240,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    final year = years[index];
                    final isSelected = provider.focusedDay.year == year;
                    return InkWell(
                      onTap: () {
                        final newDate = DateTime(
                          year,
                          provider.focusedDay.month,
                          provider.focusedDay.day,
                        );
                        provider.setFocusedDay(newDate);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? (isLight ? floralAccent : theme.colorScheme.primary) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? (isLight ? floralPrimary : theme.colorScheme.primary) 
                                : (isLight ? floralPrimary.withOpacity(0.2) : theme.dividerColor),
                          ),
                        ),
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            color: isSelected 
                                ? (isLight ? floralPrimary : theme.colorScheme.onPrimary) 
                                : (isLight ? floralPrimary : theme.textTheme.bodyMedium?.color),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
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
    final localeProvider = Provider.of<LocaleProvider>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      backgroundColor: Colors.transparent,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: 340,
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
              Text(
                l10n.settings,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Theme Section
              ExpansionTile(
                title: Text(l10n.theme, style: const TextStyle(fontWeight: FontWeight.bold)),
                leading: const Icon(Icons.palette_outlined),
                children: [
                  RadioListTile<ThemeType>(
                    title: Text(l10n.lightMode),
                    value: ThemeType.light,
                    groupValue: themeProvider.currentTheme,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    onChanged: (value) {
                      if (value != null) themeProvider.setTheme(value);
                    },
                  ),
                  RadioListTile<ThemeType>(
                    title: Text(l10n.themeGothic),
                    value: ThemeType.gothicDarkAcademia,
                    groupValue: themeProvider.currentTheme,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    onChanged: (value) {
                      if (value != null) themeProvider.setTheme(value);
                    },
                  ),
                ],
              ),

              // Language Section
              ExpansionTile(
                title: Text(l10n.language, style: const TextStyle(fontWeight: FontWeight.bold)),
                leading: const Icon(Icons.language),
                children: [
                  _buildLanguageItem(context, localeProvider, 'en', 'English', '🇺🇸'),
                  _buildLanguageItem(context, localeProvider, 'tr', 'Türkçe', '🇹🇷'),
                  _buildLanguageItem(context, localeProvider, 'de', 'Deutsch', '🇩🇪'),
                  _buildLanguageItem(context, localeProvider, 'es', 'Español', '🇪🇸'),
                  _buildLanguageItem(context, localeProvider, 'fr', 'Français', '🇫🇷'),
                  _buildLanguageItem(context, localeProvider, 'id', 'Bahasa Indonesia', '🇮🇩'),
                  _buildLanguageItem(context, localeProvider, 'ar', 'العربية', '🇸🇦'),
                  _buildLanguageItem(context, localeProvider, 'zh', '中文', '🇨🇳'),
                  _buildLanguageItem(context, localeProvider, 'hi', 'हिन्दी', '🇮🇳'),
                  _buildLanguageItem(context, localeProvider, 'pt', 'Português', '🇵🇹'),
                  _buildLanguageItem(context, localeProvider, 'ru', 'Русский', '🇷🇺'),
                ],
              ),

              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, LocaleProvider provider, String code, String name, String flag) {
    final isSelected = provider.locale?.languageCode == code;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 20)),
      title: Text(name),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        provider.setLocale(Locale(code));
      },
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
