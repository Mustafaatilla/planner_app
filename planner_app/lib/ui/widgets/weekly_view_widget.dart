import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/models/task_model.dart';
import '../../logic/calendar_provider.dart';
import '../../logic/task_provider.dart';
import '../../logic/habit_provider.dart';
import '../widgets/add_task_sheet.dart';
import 'habit_list_item.dart';

import '../widgets/general_todo_list.dart';
import '../../logic/theme_provider.dart';
import '../../core/theme.dart';

class WeeklyViewWidget extends StatefulWidget {
  final DateTime focusedDay;
  final bool showSideNavigation;

  const WeeklyViewWidget({
    super.key,
    required this.focusedDay,
    this.showSideNavigation = true,
  });

  @override
  State<WeeklyViewWidget> createState() => _WeeklyViewWidgetState();
}

class _WeeklyViewWidgetState extends State<WeeklyViewWidget> {


  @override
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 750;
    final theme = Theme.of(context);
    
    // Calculate start of week (Monday) for overlay usage
    final startOfWeek = widget.focusedDay.subtract(Duration(days: widget.focusedDay.weekday - 1));
    final days = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context);
  }

  void _showOverlay(BuildContext context, String heroTag, Widget content) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.6),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: _OverlayContent(
              heroTag: heroTag,
              content: content,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    // Calculate start of week (Monday)
    final startOfWeek = widget.focusedDay.subtract(Duration(days: widget.focusedDay.weekday - 1));
    final days = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.currentTheme == ThemeType.light;

    return Container(
      decoration: isLight 
          ? const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/textures/watercolor_bg.png'),
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: SafeArea(
        child: Column(
          children: [
            // Row 1: Mon, Tue
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _MiniGridTile(day: days[0], index: 0, onTap: () => _showDayDetails(context, days[0]))),
                  const SizedBox(width: 4),
                  Expanded(child: _MiniGridTile(day: days[1], index: 1, onTap: () => _showDayDetails(context, days[1]))),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Row 2: Wed, Thu
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _MiniGridTile(day: days[2], index: 2, onTap: () => _showDayDetails(context, days[2]))),
                  const SizedBox(width: 4),
                  Expanded(child: _MiniGridTile(day: days[3], index: 3, onTap: () => _showDayDetails(context, days[3]))),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Row 3: Fri, Sat
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _MiniGridTile(day: days[4], index: 4, onTap: () => _showDayDetails(context, days[4]))),
                  const SizedBox(width: 4),
                  Expanded(child: _MiniGridTile(day: days[5], index: 5, onTap: () => _showDayDetails(context, days[5]))),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Row 4: Sun, General
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _MiniGridTile(day: days[6], index: 6, onTap: () => _showDayDetails(context, days[6]))),
                  const SizedBox(width: 4),
                  Expanded(child: _MiniGeneralTile(onTap: () => _showGeneralDetails(context))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    // Calculate start of week (Monday)
    final startOfWeek = widget.focusedDay.subtract(Duration(days: widget.focusedDay.weekday - 1));
    
    // Generate all 7 days
    final days = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    final theme = Theme.of(context);
    final calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.currentTheme == ThemeType.light;

    Widget gridContent = Column(
      children: [
        // Row 1: Mon, Tue (2 Days)
        Expanded(
          flex: 1,
          child: Row(
            children: [
              _buildDesktopGridTile(context, days[0], 0), // Mon
              const SizedBox(width: 12),
              _buildDesktopGridTile(context, days[1], 1), // Tue
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Row 2: Wed, Thu (2 Days)
        Expanded(
          flex: 1,
          child: Row(
            children: [
              _buildDesktopGridTile(context, days[2], 2), // Wed
              const SizedBox(width: 12),
              _buildDesktopGridTile(context, days[3], 3), // Thu
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Row 3: Fri, Sat, Sun (3 Days)
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildDesktopGridTile(context, days[4], 4, isExpanded: false)), // Fri
              const SizedBox(width: 12),
              Expanded(flex: 1, child: _buildDesktopGridTile(context, days[5], 5, isExpanded: false)), // Sat
              const SizedBox(width: 12),
              Expanded(flex: 1, child: _buildDesktopGridTile(context, days[6], 6, isExpanded: false)), // Sun
            ],
          ),
        ),
      ],
    );

    if (!widget.showSideNavigation) {
      return gridContent;
    }

    // Desktop Layout with Side Navigation (and Top Bar for Light Mode)
    return Container(
      decoration: isLight 
          ? const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/textures/watercolor_bg.png'),
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: Column(
        children: [
          // Top Calendar Bar (Light Mode Only)
          if (isLight)
            _buildFloralTopBar(context),

          Expanded(
            child: Row(
              children: [
                // Previous Week Button (Hidden in Light Mode if Top Bar is used, or kept?)
                // User said "The calendar bar must look exactly like the original app layout"
                // If original had side arrows, maybe I should keep them?
                // But user also said "Include... Back/forward navigation arrows" in the top bar.
                // I'll hide side arrows in Light Mode to avoid duplication.
                if (!isLight)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        calendarProvider.setFocusedDay(
                          widget.focusedDay.subtract(const Duration(days: 7)),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.shadowColor.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: theme.colorScheme.onPrimaryContainer,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Grid
                Expanded(
                  child: gridContent,
                ),

                // Next Week Button (Hidden in Light Mode)
                if (!isLight)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        calendarProvider.setFocusedDay(
                          widget.focusedDay.add(const Duration(days: 7)),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.shadowColor.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onPrimaryContainer,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildFloralTopBar(BuildContext context) {
    final theme = Theme.of(context);
    final calendarProvider = Provider.of<CalendarProvider>(context);
    
    // Format Month Year (e.g. November 2025)
    final title = DateFormat('MMMM yyyy').format(widget.focusedDay);

    return Container(
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/textures/watercolor_bg.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           // Left Arrow
           InkWell(
             onTap: () => calendarProvider.setFocusedDay(widget.focusedDay.subtract(const Duration(days: 7))),
             child: Container(
               width: 40, height: 40,
               decoration: const BoxDecoration(
                 image: DecorationImage(image: AssetImage('assets/textures/nav_arrow_bg.png'), fit: BoxFit.cover),
                 shape: BoxShape.circle,
               ),
               child: const Icon(Icons.chevron_left, color: Color(0xFF5A463F)),
             ),
           ),
           
           const SizedBox(width: 24),

           // Month Year Title (Clickable)
           InkWell(
             onTap: () => _showCalendarDialog(context, calendarProvider),
             borderRadius: BorderRadius.circular(12),
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
               child: Text(
                 title, 
                 style: theme.textTheme.titleMedium?.copyWith(
                   fontFamily: 'Poppins', 
                   color: const Color(0xFF5A463F), 
                   fontWeight: FontWeight.bold,
                   fontSize: 22,
                 )
               ),
             ),
           ),

           const SizedBox(width: 24),
           
           // Right Arrow
           InkWell(
             onTap: () => calendarProvider.setFocusedDay(widget.focusedDay.add(const Duration(days: 7))),
             child: Container(
               width: 40, height: 40,
               decoration: const BoxDecoration(
                 image: DecorationImage(image: AssetImage('assets/textures/nav_arrow_bg.png'), fit: BoxFit.cover),
                 shape: BoxShape.circle,
               ),
               child: const Icon(Icons.chevron_right, color: Color(0xFF5A463F)),
             ),
           ),
        ],
      ),
    );
  }

  void _showCalendarDialog(BuildContext context, CalendarProvider provider) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
        backgroundColor: Colors.transparent,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            width: 320,
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
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: provider.focusedDay,
                  calendarFormat: CalendarFormat.month,
                  rowHeight: 40,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    provider.setFocusedDay(focusedDay);
                    Navigator.pop(context);
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDayDetails(BuildContext context, DateTime day) {
    _showOverlay(
      context,
      'day_${day.year}_${day.month}_${day.day}',
      _DayBlock(
        day: day,
        isProminent: true,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showGeneralDetails(BuildContext context) {
    _showOverlay(
      context,
      'day_7',
      const GeneralTodoList(),
    );
  }

  Widget _buildDesktopGridTile(BuildContext context, DateTime day, int index, {bool isExpanded = true}) {
    final widget = Hero(
      tag: 'day_${day.year}_${day.month}_${day.day}',
      child: _DayBlock(
        day: day,
        onTap: () => _showDayDetails(context, day),
      ),
    );
    
    if (isExpanded) {
      return Expanded(child: widget);
    }
    return widget;
  }
}

class _MiniGridTile extends StatelessWidget {
  final DateTime day;
  final int index;
  final VoidCallback onTap;

  const _MiniGridTile({
    required this.day,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _isSameDay(day, DateTime.now());
    final taskProvider = Provider.of<TaskProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context);
    final tasks = taskProvider.getTasksForDay(day);
    final activeHabits = habitProvider.habits.where((h) => h.isActiveOn(day)).toList();

    return Hero(
      tag: 'day_${day.year}_${day.month}_${day.day}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isToday 
                  ? theme.colorScheme.primaryContainer.withOpacity(0.4) 
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
              border: isToday 
                  ? Border.all(color: theme.colorScheme.primary.withOpacity(0.5), width: 1.5)
                  : Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Dynamic font scaling based on block height (AGGRESSIVE)
                final baseSize = (constraints.maxHeight * 0.12).clamp(12.0, 30.0);
                final headerSize = (baseSize * 1.3).clamp(16.0, 36.0);
                final badgeSize = (baseSize * 0.7).clamp(8.0, 14.0);
                final taskSize = baseSize.clamp(12.0, 24.0);
                final dotSize = (baseSize * 0.4).clamp(4.0, 8.0);
                
                // Debug: Print to verify scaling
                print('Tile Height: ${constraints.maxHeight.toStringAsFixed(1)}, Base Font: ${baseSize.toStringAsFixed(1)}px');
                
                // Dynamic task count based on available height
                final maxVisibleTasks = ((constraints.maxHeight / 40).floor() - 1).clamp(2, 5);
                final visibleTasks = tasks.take(maxVisibleTasks).toList();
                final remainingCount = tasks.length - maxVisibleTasks;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEE d').format(day),
                          style: TextStyle(
                            fontSize: headerSize,
                            fontWeight: FontWeight.bold,
                            color: isToday ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (tasks.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${tasks.length}',
                              style: TextStyle(
                                fontSize: badgeSize,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: baseSize * 0.25),
                    Divider(height: 1, thickness: 0.5, color: theme.dividerColor.withOpacity(0.5)),
                    SizedBox(height: baseSize * 0.25),
                    
                    // Task List
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...visibleTasks.map((task) => Padding(
                            padding: EdgeInsets.only(bottom: baseSize * 0.3),
                            child: Row(
                              children: [
                                Container(
                                  width: dotSize,
                                  height: dotSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: task.isCompleted ? theme.disabledColor : theme.colorScheme.primary,
                                  ),
                                ),
                                SizedBox(width: baseSize * 0.4),
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: taskSize,
                                      color: task.isCompleted ? theme.disabledColor : theme.colorScheme.onSurface,
                                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          if (remainingCount > 0)
                            Text(
                              '+$remainingCount more',
                              style: TextStyle(
                                fontSize: badgeSize,
                                fontStyle: FontStyle.italic,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Habit Dot Indicators (Bottom)
                    if (activeHabits.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: baseSize * 0.15),
                        child: Row(
                          children: activeHabits.take(5).map((habit) => Container(
                            width: dotSize + 1,
                            height: dotSize + 1,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: habit.color,
                            ),
                          )).toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _MiniGeneralTile extends StatelessWidget {
  final VoidCallback onTap;

  const _MiniGeneralTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.getGeneralTasks();
    
    final visibleTasks = tasks.take(3).toList();
    final remainingCount = tasks.length - 3;

    return Hero(
      tag: 'day_7',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GENERAL',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    if (tasks.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${tasks.length}',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Divider(height: 1, thickness: 0.5, color: theme.dividerColor.withOpacity(0.5)),
                const SizedBox(height: 2),
                
                // Task List
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...visibleTasks.map((task) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: task.isCompleted ? theme.disabledColor : theme.colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: task.isCompleted ? theme.disabledColor : theme.colorScheme.onSurface,
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )),
                      if (remainingCount > 0)
                        Text(
                          '+$remainingCount more',
                          style: TextStyle(
                            fontSize: 8,
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayBlock extends StatelessWidget {
  final DateTime day;
  final bool isProminent;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  const _DayBlock({
    required this.day,
    this.isProminent = false,
    this.onClose,
    this.onTap,
  });

  String _getNatureEmoji(int weekday) {
    switch (weekday) {
      case DateTime.monday: return '🌿';
      case DateTime.tuesday: return '🍄';
      case DateTime.wednesday: return '🐝';
      case DateTime.thursday: return '🌸';
      case DateTime.friday: return '🦋';
      case DateTime.saturday: return '🐞';
      case DateTime.sunday: return '☀️';
      default: return '🌱';
    }
  }

  // Gothic Theme Helpers
  Color _getGothicHeaderColor(int weekday) {
    switch (weekday) {
      case DateTime.monday:
      case DateTime.thursday:
      case DateTime.friday:
        return const Color(0xFF4A2328); // Deep Burgundy
      case DateTime.tuesday:
      case DateTime.wednesday:
      case DateTime.saturday:
        return const Color(0xFF3E4A2F); // Deep Olive
      case DateTime.sunday:
        return const Color(0xFF8D5524); // Bronze
      default:
        return const Color(0xFF4A2328);
    }
  }

  Color _getGothicBodyColor(int weekday) {
    // Slightly lighter/different versions for the body background if needed, 
    // or just use the surface color. The image shows colored backgrounds.
    // Let's try to match the image's card body colors which seem to be 
    // muted versions of the header or just dark textured.
    // For now, let's return a color that blends with the header but is darker.
    switch (weekday) {
      case DateTime.monday:
      case DateTime.thursday:
      case DateTime.friday:
        return const Color(0xFF2D1B1E); // Darker Burgundy
      case DateTime.tuesday:
      case DateTime.wednesday:
      case DateTime.saturday:
        return const Color(0xFF262E20); // Darker Olive
      case DateTime.sunday:
        return const Color(0xFF3E2B1F); // Darker Bronze
      default:
        return const Color(0xFF1E1E1E);
    }
  }

  Widget _buildGothicDecoration(BuildContext context, int weekday) {
    // Return a Stack of decorations based on the day
    List<Widget> decorations = [];
    
    // Common style for emojis/icons
    const double cornerOffset = 8;

    switch (weekday) {
      case DateTime.monday:
        decorations.add(Positioned(
          bottom: cornerOffset, 
          left: cornerOffset, 
          child: Opacity(
            opacity: 0.8,
            child: Image.asset('assets/textures/skull.png', width: 28, height: 28)
          )
        )); // Skull Asset
        decorations.add(Positioned(
          bottom: cornerOffset, 
          right: cornerOffset, 
          child: Opacity(
            opacity: 0.6,
            child: Image.asset('assets/textures/corner_web.png', width: 40, height: 40)
          )
        )); // Web Asset
        break;
      case DateTime.tuesday:
        decorations.add(Positioned(
          bottom: cornerOffset, 
          left: cornerOffset, 
          child: Opacity(
            opacity: 0.8,
            child: Image.asset('assets/textures/skull.png', width: 28, height: 28)
          )
        )); // Skull Asset
        decorations.add(Positioned(
          bottom: 40, 
          right: cornerOffset, 
          child: Opacity(
            opacity: 0.4,
            child: Image.asset('assets/textures/corner_web.png', width: 50, height: 50)
          )
        )); // Web Asset
        break;
      case DateTime.wednesday:
        decorations.add(Positioned(
          bottom: cornerOffset, 
          left: cornerOffset, 
          child: Opacity(
            opacity: 0.8,
            child: Image.asset('assets/textures/key.png', width: 24, height: 24)
          )
        )); // Key Asset
        decorations.add(Positioned(
          bottom: cornerOffset, 
          right: cornerOffset, 
          child: Opacity(
            opacity: 0.6,
            child: Image.asset('assets/textures/corner_web.png', width: 40, height: 40)
          )
        )); // Web Asset
        break;
      case DateTime.thursday:
        decorations.add(Positioned(
          bottom: cornerOffset, 
          right: cornerOffset, 
          child: Opacity(
            opacity: 0.8,
            child: Image.asset('assets/textures/key.png', width: 24, height: 24)
          )
        )); // Key Asset
        decorations.add(Positioned(
          bottom: cornerOffset, 
          left: cornerOffset, 
          child: Opacity(
            opacity: 0.6,
            child: Image.asset('assets/textures/thorn_branch.png', width: 100, height: 30, fit: BoxFit.contain)
          )
        )); // Thorn Branch Asset
        break;
      case DateTime.friday:
        decorations.add(Positioned(
          top: cornerOffset, 
          right: cornerOffset, 
          child: Opacity(
            opacity: 0.8,
            child: Image.asset('assets/textures/moon.png', width: 24, height: 24)
          )
        )); // Moon Asset
        decorations.add(Positioned(
          bottom: cornerOffset, 
          left: cornerOffset, 
          child: Opacity(
            opacity: 0.6,
            child: Image.asset('assets/textures/corner_web.png', width: 40, height: 40)
          )
        )); // Web Asset
        break;
      case DateTime.saturday:
        decorations.add(Positioned(
          top: cornerOffset, 
          right: cornerOffset, 
          child: Opacity(
            opacity: 0.8,
            child: Image.asset('assets/textures/moon.png', width: 24, height: 24)
          )
        )); // Moon Asset
        decorations.add(Positioned(
          bottom: cornerOffset, 
          left: cornerOffset, 
          child: Opacity(
            opacity: 0.8,
            child: Image.asset('assets/textures/skeleton_hand.png', width: 36, height: 50, fit: BoxFit.contain)
          )
        )); // Skeleton Hand Asset
        break;
      case DateTime.sunday:
        decorations.add(Positioned(
          top: cornerOffset, 
          right: cornerOffset, 
          child: Opacity(
            opacity: 0.8,
            child: Image.asset('assets/textures/moon.png', width: 24, height: 24)
          )
        )); // Moon Asset
        break;
    }

    return Stack(children: decorations);
  }

  Widget _buildFloralDecoration(BuildContext context, int weekday) {
    // This function now only handles the background decoration if needed, 
    // but stickers are moved to the header.
    // We can keep it empty or return a placeholder if we want to keep the signature.
    return const SizedBox.shrink(); 
  }

  // Helper to get sticker asset name
  String _getStickerAsset(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'leaf.png';
      case DateTime.tuesday: return 'mushroom.png';
      case DateTime.wednesday: return 'butterfly.png';
      case DateTime.thursday: return 'pink_blossom.png';
      case DateTime.friday: return 'butterfly_2.png';
      case DateTime.saturday: return 'ladybug.png';
      case DateTime.sunday: return 'sun.png';
      default: return 'pink_blossom.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final tasks = taskProvider.getTasksForDay(day);
    final habits = habitProvider.habits.where((h) => h.isActiveOn(day)).toList();
    final isToday = _isSameDay(day, DateTime.now());

    final isLight = themeProvider.currentTheme == ThemeType.light;
    final isGothic = themeProvider.currentTheme == ThemeType.gothicDarkAcademia;

    // Use the specific Gothic colors if in that mode, otherwise fallback to theme colors
    final headerColor = isGothic ? _getGothicHeaderColor(day.weekday) : theme.colorScheme.tertiary;
    final cardBackgroundColor = isGothic ? _getGothicBodyColor(day.weekday) : theme.colorScheme.surface;
    final borderColor = isGothic ? headerColor.withOpacity(0.5) : theme.colorScheme.secondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isGothic 
            ? GothicDecorations.dayCard(cardBackgroundColor)
            : isLight
              ? FloralDecorations.dayCard(cardBackgroundColor)
              : BoxDecoration(
                  color: cardBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3E2723).withOpacity(0.2), // Brown shadow
                      blurRadius: 0, // Retro hard shadow
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
        child: ClipRRect(
          borderRadius: isLight ? BorderRadius.circular(24) : BorderRadius.circular(18),
          child: Stack(
            children: [
              // Gothic Decorations (Background Layer)
              if (isGothic)
                Positioned.fill(child: _buildGothicDecoration(context, day.weekday)),
              
              // Floral Decorations (Background Layer) - REMOVED as it's now handled by Container decoration
              // if (isLight)
              //   Positioned.fill(child: _buildFloralDecoration(context, day.weekday)),

              Column(
                children: [
                  // HEADER STRIP
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: isLight
                      ? const BoxDecoration(
                          color: Color(0xFFBFD8BD), // Fallback green to cover gaps
                          image: DecorationImage(
                            image: AssetImage('assets/textures/green_banner.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        )
                      : BoxDecoration(
                          color: headerColor, 
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
                      children: [
                        // Date & Day Name
                        Row(
                          children: [
                            Text(
                              DateFormat('d').format(day),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isLight ? const Color(0xFF2D4633) : Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('EEEE').format(day),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isLight ? const Color(0xFF2D4633).withOpacity(0.9) : Colors.white.withOpacity(0.9),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        
                        // Sticker
                        if (isLight)
                          Positioned(
                            right: -8,
                            top: -8,
                            child: Image.asset(
                              'assets/textures/${_getStickerAsset(day.weekday)}',
                              width: 50,
                              height: 50,
                            ),
                          ),

                        // Buttons
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: isLight ? 40.0 : 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isProminent)
                                  InkWell(
                                    onTap: () => _showAddTaskSheet(context, day),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: isLight ? const Color(0xFF2D4633) : Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                if (isProminent && onClose != null)
                                   InkWell(
                                    onTap: onClose,
                                    child: Icon(
                                      Icons.close,
                                      color: isLight ? const Color(0xFF2D4633) : Colors.white,
                                      size: 22,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // BODY (Tasks)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Tasks List
                                  ...tasks.map((task) => _TaskItem(task: task, isProminent: isProminent)).toList(),
                                  const SizedBox(height: 8),
                                  // Habits List
                                  if (habits.isNotEmpty) ...[
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: habits.map((habit) => HabitListItem(habit: habit, date: day)).toList(),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                  
                                  if (tasks.isEmpty && habits.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Center(
                                        child: Text(
                                          'Empty',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.disabledColor,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              // FAB for Add Task (Bottom-Right) - Only in Prominent View
              if (isProminent)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: isLight
                      ? InkWell(
                          onTap: () => _showAddTaskSheet(context, day),
                          child: Container(
                            width: 140,
                            height: 48,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/textures/add_task_pill.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Add a task...',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : FloatingActionButton(
                          onPressed: () => _showAddTaskSheet(context, day),
                          backgroundColor: theme.colorScheme.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: theme.colorScheme.secondary, width: 2.0),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 32),
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context, DateTime selectedDate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskSheet(selectedDate: selectedDate),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final bool isProminent;

  const _TaskItem({
    required this.task,
    this.isProminent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.currentTheme == ThemeType.light;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8),
        color: theme.colorScheme.errorContainer,
        child: Icon(Icons.delete, size: isProminent ? 24 : 16, color: theme.colorScheme.onErrorContainer),
      ),
      onDismissed: (_) => taskProvider.deleteTask(task.id),
      child: GestureDetector(
        onSecondaryTapUp: (details) => _showContextMenu(context, details.globalPosition, taskProvider),
        onLongPressStart: (details) => _showContextMenu(context, details.globalPosition, taskProvider),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: isProminent ? 0 : 4),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: isLight
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/textures/bubble_texture.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                )
              : BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(isProminent ? 12 : 6),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.2),
                  ),
                ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: isLight
                  ? InkWell(
                      onTap: () => taskProvider.toggleTaskCompletion(task.id),
                      child: task.isCompleted
                          ? Image.asset(
                              'assets/images/checkbox_checked_floral.png',
                              fit: BoxFit.contain,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE0C9C9), // Pastel Beige
                                  width: 2.0,
                                ),
                              ),
                            ),
                    )
                  : Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => taskProvider.toggleTaskCompletion(task.id),
                      shape: const CircleBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: isProminent 
                          ? theme.textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted ? theme.disabledColor : const Color(0xFF5A463F), // Soft Brown
                              fontFamily: 'Poppins',
                            )
                          : theme.textTheme.bodySmall?.copyWith(
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted ? theme.disabledColor : const Color(0xFF5A463F), // Soft Brown
                              fontFamily: 'Poppins',
                            ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isProminent && task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          task.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 15, // Slightly larger
                            color: const Color(0xFF4A3B32), // Darker brown for contrast
                            fontWeight: FontWeight.w600, // Bolder
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position, TaskProvider provider) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'delete') {
        provider.deleteTask(task.id);
      }
    });
  }
}

class _OverlayContent extends StatelessWidget {
  final String heroTag;
  final Widget content;

  const _OverlayContent({required this.heroTag, required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 750;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: isMobile ? size.width * 0.9 : size.width * 0.6,
          height: isMobile ? size.height * 0.8 : size.height * 0.7,
          constraints: isMobile ? null : const BoxConstraints(
            minWidth: 500, maxWidth: 900,
            minHeight: 400, maxHeight: 800
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: content,
          ),
        ),
      ),
    );
  }
}


