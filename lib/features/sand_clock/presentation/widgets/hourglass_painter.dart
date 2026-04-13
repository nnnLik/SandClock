import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class HourglassPainter extends CustomPainter {
  HourglassPainter({
    required this.progress,
    required this.sandColor,
    this.frameColor = AppColors.hourglassFrame,
    this.backgroundColor = AppColors.hourglassCanvasBackground,
  });

  final double progress;
  final Color sandColor;
  final Color frameColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = w * 0.08;
    final neckY = h / 2;
    final bottomY = h - p;

    final upperPath = Path()
      ..moveTo(p, p)
      ..lineTo(w - p, p)
      ..lineTo(w / 2, neckY)
      ..close();

    final lowerPath = Path()
      ..moveTo(w / 2, neckY)
      ..lineTo(p, bottomY)
      ..lineTo(w - p, bottomY)
      ..close();

    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final hUpper = neckY - p;
    final hLower = bottomY - neckY;
    final t = progress.clamp(0.0, 1.0);

    final ySandTop = p + hUpper * t;
    final upperSandPath = _upperSandPath(w, p, neckY, ySandTop);
    if (upperSandPath != null) {
      canvas.drawPath(
        upperSandPath,
        Paint()
          ..color = sandColor
          ..style = PaintingStyle.fill,
      );
    }

    final yBoundary = bottomY - hLower * t;
    final lowerSandPath = _lowerSandPath(w, p, neckY, bottomY, yBoundary);
    if (lowerSandPath != null) {
      canvas.drawPath(
        lowerSandPath,
        Paint()
          ..color = sandColor
          ..style = PaintingStyle.fill,
      );
    }

    final stroke = Paint()
      ..color = frameColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.0, w * 0.012)
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(upperPath, stroke);
    canvas.drawPath(lowerPath, stroke);
  }

  static double _xLeftUpper(double w, double p, double neckY, double y) {
    final dy = neckY - p;
    if (dy <= 0) return w / 2;
    final u = (y - p) / dy;
    return p + u * (w / 2 - p);
  }

  static double _xRightUpper(double w, double p, double neckY, double y) {
    final dy = neckY - p;
    if (dy <= 0) return w / 2;
    final u = (y - p) / dy;
    return (w - p) - u * (w - p - w / 2);
  }

  Path? _upperSandPath(double w, double p, double neckY, double ySandTop) {
    if (ySandTop >= neckY - 1e-6) return null;
    final y0 = ySandTop.clamp(p, neckY);
    final xl = _xLeftUpper(w, p, neckY, y0);
    final xr = _xRightUpper(w, p, neckY, y0);
    return Path()
      ..moveTo(xl, y0)
      ..lineTo(xr, y0)
      ..lineTo(w / 2, neckY)
      ..close();
  }

  static double _xLeftLower(
    double w,
    double p,
    double neckY,
    double bottomY,
    double y,
  ) {
    final dy = bottomY - neckY;
    if (dy <= 0) return w / 2;
    final u = (y - neckY) / dy;
    return w / 2 + u * (p - w / 2);
  }

  static double _xRightLower(
    double w,
    double p,
    double neckY,
    double bottomY,
    double y,
  ) {
    final dy = bottomY - neckY;
    if (dy <= 0) return w / 2;
    final u = (y - neckY) / dy;
    return w / 2 + u * (w - p - w / 2);
  }

  Path? _lowerSandPath(
    double w,
    double p,
    double neckY,
    double bottomY,
    double yBoundary,
  ) {
    if (yBoundary >= bottomY - 1e-6) return null;
    final y0 = yBoundary.clamp(neckY, bottomY);
    final xl = _xLeftLower(w, p, neckY, bottomY, y0);
    final xr = _xRightLower(w, p, neckY, bottomY, y0);
    return Path()
      ..moveTo(xl, y0)
      ..lineTo(p, bottomY)
      ..lineTo(w - p, bottomY)
      ..lineTo(xr, y0)
      ..close();
  }

  @override
  bool shouldRepaint(covariant HourglassPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.sandColor != sandColor ||
        oldDelegate.frameColor != frameColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }

  @override
  bool? hitTest(Offset position) => false;
}
