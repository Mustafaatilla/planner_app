import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'logic/calendar_provider.dart';
import 'logic/task_provider.dart';
import 'logic/habit_provider.dart';
import 'logic/theme_provider.dart';
import 'ui/screens/calendar_screen.dart';

void main() {
  runApp(const PlannerApp());
}

class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Next-Gen Planner',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const CalendarScreen(),
          );
        },
      ),
    );
  }
}
