import 'package:flutter/material.dart';

class AppThemePreset {
  const AppThemePreset({
    required this.name,
    required this.schemeColor,
    required this.sandColor,
  });

  final String name;
  final Color schemeColor;
  final Color sandColor;
}

abstract final class AppThemePresets {
  AppThemePresets._();

  static const AppThemePreset desert = AppThemePreset(
    name: 'Песок пустыни',
    schemeColor: Color(0xFFC49A49),
    sandColor: Color(0xFFD4A017),
  );

  static const AppThemePreset neon = AppThemePreset(
    name: 'Неон',
    schemeColor: Color(0xFF00BCD4),
    sandColor: Color(0xFF18FFFF),
  );

  static const AppThemePreset monochrome = AppThemePreset(
    name: 'Монохром',
    schemeColor: Color(0xFF607D8B),
    sandColor: Color(0xFFB0BEC5),
  );

  static const AppThemePreset retroWood = AppThemePreset(
    name: 'Ретро дерево',
    schemeColor: Color(0xFF795548),
    sandColor: Color(0xFFA1887F),
  );

  static const List<AppThemePreset> all = <AppThemePreset>[
    desert,
    neon,
    monochrome,
    retroWood,
  ];
}
