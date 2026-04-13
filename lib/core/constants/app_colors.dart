import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  static const Color seed = Color(0xFFD4A017);

  static const Color sandDefault = Color(0xFFD4A017);

  static const List<Color> sandPresets = <Color>[
    Color(0xFFD4A017),
    Color(0xFFC9A227),
    Color(0xFFB8860B),
    Color(0xFFE6C35C),
    Color(0xFF8B7355),
    Color(0xFF6B8E23),
  ];

  static const Color hourglassFrame = Color(0xFF4A4A4A);

  static const Color hourglassCanvasBackground = Color(0xFFF5F0E6);
}
