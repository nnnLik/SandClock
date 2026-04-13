import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/sand_clock/presentation/screens/sand_clock_screen.dart';

class SandClockApp extends StatefulWidget {
  const SandClockApp({super.key});

  @override
  State<SandClockApp> createState() => _SandClockAppState();
}

class _SandClockAppState extends State<SandClockApp> {
  Color _schemeColor = AppColors.seed;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light(_schemeColor),
      darkTheme: AppTheme.dark(_schemeColor),
      restorationScopeId: 'sand_clock_app',
      home: SandClockScreen(
        schemeColor: _schemeColor,
        onSchemeColorChanged: (color) {
          setState(() => _schemeColor = color);
        },
      ),
    );
  }
}
