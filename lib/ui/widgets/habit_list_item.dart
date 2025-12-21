import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/habit_model.dart';
import '../../logic/habit_provider.dart';

class HabitListItem extends StatelessWidget {
  final Habit habit;
  final DateTime date;
  final bool isProminent;

  const HabitListItem({
    super.key,
    required this.habit,
    required this.date,
    this.isProminent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final isCompleted = habit.isCompletedOn(date);

    final now = DateTime.now();
    final isFuture = date.isAfter(DateTime(now.year, now.month, now.day, 23, 59, 59));

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.onErrorContainer),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Habit?"),
              content: const Text("This will remove the habit permanently."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        habitProvider.deleteHabit(habit.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${habit.title} deleted'),
            behavior: SnackBarBehavior.floating,
            width: 200,
          ),
        );
      },
      child: GestureDetector(
        onTap: isFuture 
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Cannot complete future habits"),
                    behavior: SnackBarBehavior.floating,
                    width: 250,
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              }
            : () async {
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final isPast = date.isBefore(today);

                if (isPast && !isCompleted) {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Completion'),
                      content: const Text('Did you really complete this habit in the past?'),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('No', style: TextStyle(fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Yes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    habitProvider.toggleHabitCompletion(habit.id, date);
                  }
                } else {
                  habitProvider.toggleHabitCompletion(habit.id, date);
                }
              },
        onSecondaryTapUp: (details) async {
          final result = await showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              details.globalPosition.dx + 1,
              details.globalPosition.dy + 1,
            ),
            items: [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          );
          
          if (result == 'delete' && context.mounted) {
             final confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Delete Habit?"),
                  content: const Text("This will remove the habit permanently."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              habitProvider.deleteHabit(habit.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${habit.title} deleted'),
                    behavior: SnackBarBehavior.floating,
                    width: 200,
                  ),
                );
              }
            }
          }
        },
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Delete Habit', style: TextStyle(color: Colors.red)),
                    onTap: () async {
                      Navigator.pop(context); // Close bottom sheet
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Habit?"),
                            content: const Text("This will remove the habit permanently."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        habitProvider.deleteHabit(habit.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${habit.title} deleted'),
                              behavior: SnackBarBehavior.floating,
                              width: 200,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: Opacity(
          opacity: isFuture ? 0.5 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(
              horizontal: isProminent ? 4.0 : 2.0, 
              vertical: isProminent ? 4.0 : 2.0
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isProminent ? 12.0 : 8.0, 
              vertical: isProminent ? 8.0 : 4.0
            ),
            decoration: BoxDecoration(
              color: isCompleted
                  ? habit.color.withOpacity(0.2)
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(isProminent ? 24 : 16),
              border: Border.all(
                color: isCompleted ? habit.color.withOpacity(0.5) : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isProminent ? 24 : 20,
                  height: isProminent ? 24 : 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? habit.color : Colors.transparent,
                    border: Border.all(
                      color: habit.color,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? Icon(Icons.check, size: isProminent ? 16 : 12, color: Colors.white)
                      : (isFuture 
                          ? Icon(Icons.lock_outline, size: isProminent ? 16 : 12, color: theme.disabledColor) 
                          : null),
                ),
                SizedBox(width: isProminent ? 12 : 8),
                Flexible(
                  child: Text(
                    habit.title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: isProminent ? 16 : 12,
                      fontWeight: FontWeight.w500,
                      color: isCompleted ? habit.color.withOpacity(0.9) : theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
