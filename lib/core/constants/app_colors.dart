import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  static const Color seed = Color(0xFFD4A017);

  static const Color sandDefault = Color(0xFFD4A017);

  static const List<Color> sandPresets = <Color>[
    Color(0xFFD4A017),
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFF6A1B9A),
    Color(0xFFC62828),
    Color(0xFF00897B),
    Color(0xFFEF6C00),
    Color(0xFF37474F),
  ];

  static const Color hourglassFrame = Color(0xFF4A4A4A);

  static const Color hourglassCanvasBackground = Color(0xFFF5F0E6);
}
