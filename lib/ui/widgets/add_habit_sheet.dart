import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/habit_model.dart';
import '../../logic/habit_provider.dart';
import 'package:planner_app/l10n/app_localizations.dart';

enum HabitDuration { oneWeek, oneMonth, permanent, custom }

class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _customDaysController = TextEditingController();
  Color _selectedColor = Colors.blue;
  HabitDuration _selectedDuration = HabitDuration.permanent;

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _customDaysController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      DateTime? endDate;
      final now = DateTime.now();
      
      switch (_selectedDuration) {
        case HabitDuration.oneWeek:
          endDate = now.add(const Duration(days: 7));
          break;
        case HabitDuration.oneMonth:
          endDate = DateTime(now.year, now.month + 1, now.day);
          break;
        case HabitDuration.custom:
          if (_customDaysController.text.isNotEmpty) {
            final days = int.tryParse(_customDaysController.text) ?? 0;
            if (days > 0) {
              endDate = now.add(Duration(days: days));
            }
          }
          break;
        case HabitDuration.permanent:
          endDate = null;
          break;
      }

      final newHabit = Habit(
        title: _titleController.text,
        color: _selectedColor,
        startDate: now,
        endDate: endDate,
      );

      Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Text(
                    l10n.newHabit,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.habitTitle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.habitTitleHint;
                      }
                      return null;
                    },
                    autofocus: true,
                  ),
                  const SizedBox(height: 24),
                   Text(l10n.duration, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SegmentedButton<HabitDuration>(
                      segments: [
                        ButtonSegment(
                          value: HabitDuration.oneWeek,
                          label: Text(l10n.oneWeek),
                        ),
                        ButtonSegment(
                          value: HabitDuration.oneMonth,
                          label: Text(l10n.oneMonth),
                        ),
                        ButtonSegment(
                          value: HabitDuration.custom,
                          label: Text(l10n.custom),
                        ),
                        ButtonSegment(
                          value: HabitDuration.permanent,
                          label: Text(l10n.permanent),
                        ),
                      ],
                      selected: {_selectedDuration},
                      onSelectionChanged: (Set<HabitDuration> newSelection) {
                        setState(() {
                          _selectedDuration = newSelection.first;
                        });
                      },
                    ),
                  ),
                  if (_selectedDuration == HabitDuration.custom) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _customDaysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.durationDays,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                        suffixText: l10n.daysSuffix,
                      ),
                      validator: (value) {
                        if (_selectedDuration == HabitDuration.custom) {
                          if (value == null || value.isEmpty) {
                            return l10n.enterDuration;
                          }
                          final days = int.tryParse(value);
                          if (days == null || days <= 0) {
                            return l10n.validNumber;
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                   Text(l10n.color, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _colors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: _selectedColor == color
                                ? Border.all(color: theme.colorScheme.onSurface, width: 2.5)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _selectedColor == color
                              ? const Icon(Icons.check, color: Colors.white, size: 24)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveHabit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      l10n.addHabitTooltip, // Reusing existing key or new one "Add Habit"
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
