import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:planner_app/l10n/app_localizations.dart';
import 'core/theme.dart';
import 'logic/calendar_provider.dart';
import 'logic/task_provider.dart';
import 'logic/habit_provider.dart';
import 'logic/theme_provider.dart';
import 'logic/locale_provider.dart';
import 'ui/screens/calendar_screen.dart';
import 'ui/screens/language_selection_screen.dart';

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
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            title: 'Next-Gen Planner',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: localeProvider.isFirstLaunch 
                ? const LanguageSelectionScreen() 
                : const CalendarScreen(),
          );
        },
      ),
    );
  }
}
