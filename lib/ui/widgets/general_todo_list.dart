import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/task_provider.dart';
import 'package:planner_app/l10n/app_localizations.dart';
import '../../data/models/task_model.dart';
import 'add_task_sheet.dart';
import '../../logic/theme_provider.dart';
import '../../core/theme.dart';

class GeneralTodoList extends StatefulWidget {
  const GeneralTodoList({super.key});

  @override
  State<GeneralTodoList> createState() => _GeneralTodoListState();
}

class _GeneralTodoListState extends State<GeneralTodoList> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.getGeneralTasks();
    final l10n = AppLocalizations.of(context)!;
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isGothic = themeProvider.currentTheme == ThemeType.gothicDarkAcademia;
    final isLight = themeProvider.currentTheme == ThemeType.light;

    final containerColor = isGothic ? const Color(0xFF1E1E1E) : theme.colorScheme.surface;
    final headerColor = isGothic ? const Color(0xFF2C2C2C) : theme.colorScheme.tertiary;
    final borderColor = isGothic ? const Color(0xFF3E4A2F) : theme.colorScheme.secondary;

    return Container(
      // width: 280, // Removed fixed width to prevent overflow
      decoration: isGothic 
          ? GothicDecorations.sidebar 
          : isLight
            ? FloralDecorations.sidebar
            : BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3E2723).withOpacity(0.2),
                    blurRadius: 0,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: isLight
              ? const BoxDecoration(
                  color: Color(0xFFBFD8BD), // Fallback green
                  image: DecorationImage(
                    image: AssetImage('assets/textures/sidebar_header_strip.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                )
              : BoxDecoration(
                  color: headerColor, // Deep Forest Green or Dark Grey
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                ),
            child: Row(
              children: [
                Icon(Icons.format_list_bulleted, color: isLight ? const Color(0xFF4A3C35) : Colors.white),
                const SizedBox(width: 8),
                Text(
                  l10n.generalTodo,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isLight ? const Color(0xFF4A3C35) : Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Spacer(),
                if (!isLight)
                  Text(isGothic ? '' : '🪴', style: const TextStyle(fontSize: 20)), // Rose or Plant
              ],
            ),
          ),
          
          // List
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _GeneralTaskCard(task: task);
                  },
                ),

                // Decorative Plant/Rose Icon (Bottom Right) - Moved to top of stack
                Positioned(
                  bottom: isLight ? 0 : -20,
                  right: isLight ? 0 : -20,
                  child: IgnorePointer( // Prevent blocking clicks
                    child: Opacity(
                      opacity: isGothic ? 0.15 : (isLight ? 1.0 : 0.05),
                      child: isGothic 
                        ? Image.asset('assets/textures/skeleton_hand.png', width: 200, height: 200, fit: BoxFit.contain)
                        : isLight
                          ? Image.asset('assets/textures/floral_bouquet.png', width: 220, height: 220, fit: BoxFit.contain)
                          : Icon(
                              Icons.local_florist,
                              size: 150,
                              color: theme.colorScheme.primary,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: isGothic ? const TextStyle(color: Colors.white) : null,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.addTask,
                      hintStyle: isGothic ? TextStyle(color: Colors.white.withOpacity(0.5)) : null,
                      prefixIcon: const Icon(Icons.add),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                      ),
                      filled: true,
                      fillColor: isGothic ? const Color(0xFF2C2C2C) : theme.colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        taskProvider.addTask(Task(
                          id: DateTime.now().toString(),
                          title: value,
                          date: null, // General tasks have null date
                          isCompleted: false,
                        ));
                        _controller.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    final value = _controller.text;
                    if (value.isNotEmpty) {
                      taskProvider.addTask(Task(
                        id: DateTime.now().toString(),
                        title: value,
                        date: null,
                        isCompleted: false,
                      ));
                      _controller.clear();
                    }
                  },
                  icon: const Icon(Icons.send_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTaskSheet(selectedDate: null),
    );
  }
}

class _GeneralTaskCard extends StatelessWidget {
  final Task task;

  const _GeneralTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.currentTheme == ThemeType.light;
    final isGothic = themeProvider.currentTheme == ThemeType.gothicDarkAcademia;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: theme.colorScheme.errorContainer,
        child: Icon(Icons.delete, color: theme.colorScheme.onErrorContainer),
      ),
      onDismissed: (_) {
        taskProvider.deleteTask(task.id);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Dynamic font sizing based on available width
          final width = constraints.maxWidth;
          final titleFontSize = width > 200 ? 14.0 : (width > 150 ? 12.0 : 11.0);
          final subtitleFontSize = width > 200 ? 12.0 : (width > 150 ? 11.0 : 10.0);
          final iconSize = width > 200 ? 20.0 : 16.0;
          final checkboxScale = width > 200 ? 1.0 : 0.85;
          
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: isLight
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/textures/general_todo_bubble.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                )
              : BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                // Checkbox
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
                        side: isGothic ? const BorderSide(color: Colors.white, width: 2) : null,
                      ),
                ),
                const SizedBox(width: 12),
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted 
                              ? theme.disabledColor 
                              : (isGothic ? Colors.white : const Color(0xFF4A3B32)), // White for Gothic
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600, // Bolder
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.description.isNotEmpty)
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                // Delete button
                IconButton(
                  icon: isLight 
                    ? Image.asset('assets/textures/trash_can.png', width: iconSize, height: iconSize)
                    : Icon(Icons.delete_outline, size: iconSize),
                  onPressed: () => taskProvider.deleteTask(task.id),
                  color: theme.disabledColor,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
