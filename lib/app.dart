import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/sand_clock/presentation/screens/sand_clock_screen.dart';

class SandClockApp extends StatelessWidget {
  const SandClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      restorationScopeId: 'sand_clock_app',
      home: const SandClockScreen(),
    );
  }
}
