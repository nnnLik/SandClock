import 'dart:math' as math;

import 'package:flutter/material.dart';

class HourglassPainter extends CustomPainter {
  HourglassPainter({
    required this.progress,
    required this.sandColor,
    this.frameColor = const Color(0xFFF5F0E6),
  });

  final double progress;
  final Color sandColor;
  final Color frameColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = w * 0.1;
    final neckY = h / 2;
    final bottomY = h - p;
    final cx = w / 2;

    final upperPath = Path()
      ..moveTo(p, p)
      ..quadraticBezierTo(cx, p + p * 0.18, w - p, p)
      ..lineTo(cx, neckY)
      ..close();

    final lowerPath = Path()
      ..moveTo(cx, neckY)
      ..lineTo(p, bottomY)
      ..quadraticBezierTo(cx, bottomY - p * 0.2, w - p, bottomY)
      ..close();

    final hUpper = neckY - p;
    final hLower = bottomY - neckY;
    final t = progress.clamp(0.0, 1.0);
    const maxFillRatio = 0.85;
    final upperFillRatio = (1.0 - t) * maxFillRatio;
    final lowerFillRatio = t * maxFillRatio;

    final glassFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.02),
          Colors.black.withValues(alpha: 0.08),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(upperPath, glassFill);
    canvas.drawPath(lowerPath, glassFill);

    final ySandTop = neckY - hUpper * upperFillRatio;
    final upperSandPath = _upperSandPath(w, p, neckY, ySandTop);
    if (upperSandPath != null) {
      canvas.drawPath(
        upperSandPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              sandColor.withValues(alpha: 0.92),
              sandColor.withValues(alpha: 0.8),
            ],
          ).createShader(upperPath.getBounds())
          ..style = PaintingStyle.fill,
      );
    }

    final yBoundary = bottomY - hLower * lowerFillRatio;
    final lowerSandPath = _lowerSandPath(w, p, neckY, bottomY, yBoundary);
    if (lowerSandPath != null) {
      canvas.drawPath(
        lowerSandPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              sandColor.withValues(alpha: 0.88),
              sandColor,
            ],
          ).createShader(lowerPath.getBounds())
          ..style = PaintingStyle.fill,
      );
    }

    if (t > 0.0 && t < 1.0) {
      final streamTop = neckY - p * 0.12;
      final streamBottom = yBoundary.clamp(neckY + p * 0.18, bottomY - p * 0.12);
      final streamWidth = math.max(1.4, w * 0.011) * (1.0 - 0.3 * t);
      final streamPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            sandColor.withValues(alpha: 0.95),
            sandColor.withValues(alpha: 0.35),
          ],
        ).createShader(
          Rect.fromCenter(
            center: Offset(cx, (streamTop + streamBottom) / 2),
            width: streamWidth * 2,
            height: streamBottom - streamTop,
          ),
        )
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = streamWidth;
      canvas.drawLine(
        Offset(cx, streamTop),
        Offset(cx, streamBottom),
        streamPaint,
      );
    }

    final stroke = Paint()
      ..color = frameColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.0, w * 0.012)
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(upperPath, stroke);
    canvas.drawPath(lowerPath, stroke);
    canvas.drawCircle(
      Offset(cx, neckY),
      math.max(1.8, w * 0.008),
      Paint()..color = frameColor.withValues(alpha: 0.8),
    );
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
        oldDelegate.frameColor != frameColor;
  }

  @override
  bool? hitTest(Offset position) => false;
}
