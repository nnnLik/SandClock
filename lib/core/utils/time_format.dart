import 'dart:math' as math;

String formatMmSs(int totalSeconds) {
  final s = math.max(0, totalSeconds);
  final m = s ~/ 60;
  final sec = s % 60;
  return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
}
