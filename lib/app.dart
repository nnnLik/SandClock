import 'package:flutter/material.dart';

import 'core/constants/app_theme_presets.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/sand_clock/presentation/screens/sand_clock_screen.dart';

class SandClockApp extends StatefulWidget {
  const SandClockApp({super.key});

  @override
  State<SandClockApp> createState() => _SandClockAppState();
}

class _SandClockAppState extends State<SandClockApp> {
  AppThemePreset _selectedTheme = AppThemePresets.desert;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light(_selectedTheme.schemeColor),
      darkTheme: AppTheme.dark(_selectedTheme.schemeColor),
      restorationScopeId: 'sand_clock_app',
      home: SandClockScreen(
        selectedTheme: _selectedTheme,
        onThemeChanged: (theme) {
          setState(() => _selectedTheme = theme);
        },
      ),
    );
  }
}
