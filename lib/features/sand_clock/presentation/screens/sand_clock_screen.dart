import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme_presets.dart';
import '../../../../core/utils/time_format.dart';
import '../widgets/hourglass_painter.dart';
import '../widgets/sand_color_picker_dialog.dart';

class SandClockScreen extends StatefulWidget {
  const SandClockScreen({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  final AppThemePreset selectedTheme;
  final ValueChanged<AppThemePreset> onThemeChanged;

  @override
  State<SandClockScreen> createState() => _SandClockScreenState();
}

class _SandClockScreenState extends State<SandClockScreen>
    with TickerProviderStateMixin {
  final TextEditingController _hoursController = TextEditingController(
    text: '${AppConstants.defaultHours}',
  );
  final TextEditingController _minutesController = TextEditingController(
    text: '${AppConstants.defaultMinutes}',
  );
  final TextEditingController _secondsController = TextEditingController(
    text: '${AppConstants.defaultSeconds}',
  );

  late final AnimationController _controller;
  late final AudioPlayer _audioPlayer;

  int _runTotalSeconds = AppConstants.defaultSeconds;

  int _lastValidSeconds = AppConstants.defaultSeconds;

  late AppThemePreset _selectedTheme;
  late Color _sandColor;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.selectedTheme;
    _sandColor = _selectedTheme.sandColor;
    _audioPlayer = AudioPlayer()
      ..setPlayerMode(PlayerMode.lowLatency)
      ..setReleaseMode(ReleaseMode.stop);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: AppConstants.animationControllerPlaceholderSeconds),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener(_onAnimationStatus);
  }

  @override
  void didUpdateWidget(covariant SandClockScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTheme.name != widget.selectedTheme.name && !_inputLocked) {
      _selectedTheme = widget.selectedTheme;
      _sandColor = _selectedTheme.sandColor;
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _onTimeUp();
    }
  }

  Future<void> _onTimeUp() async {
    if (_isMuted) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(
        AssetSource('sounds/timer_done.wav'),
        volume: 1.0,
      );
    } catch (_) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  int? _parsePositiveSeconds() {
    final h = int.tryParse(_hoursController.text.trim()) ?? 0;
    final m = int.tryParse(_minutesController.text.trim()) ?? 0;
    final s = int.tryParse(_secondsController.text.trim()) ?? 0;
    if (h < 0 || m < 0 || s < 0) return null;
    final total = h * 3600 + m * 60 + s;
    if (total <= 0) return null;
    return total;
  }

  bool get _canStart {
    return _parsePositiveSeconds() != null &&
        !_controller.isAnimating &&
        (_controller.value == 0.0 || _controller.value == 1.0);
  }

  bool get _inputLocked =>
      _controller.isAnimating ||
      (_controller.value > 0.0 && _controller.value < 1.0);

  bool get _isPaused =>
      !_controller.isAnimating &&
      _controller.value > 0.0 &&
      _controller.value < 1.0;

  int get _remainingSeconds {
    if (_runTotalSeconds <= 0) return 0;
    final r = ((_runTotalSeconds) * (1.0 - _controller.value)).ceil();
    return math.max(0, r);
  }

  void _start() {
    final n = _parsePositiveSeconds();
    if (n == null) return;
    _lastValidSeconds = n;
    _runTotalSeconds = n;
    _controller.duration = Duration(seconds: n);
    _controller.reset();
    _controller.forward();
  }

  void _reset() {
    _controller.stop();
    _controller.reset();
    final n = _parsePositiveSeconds();
    if (n != null) {
      _lastValidSeconds = n;
      _runTotalSeconds = n;
    } else {
      _runTotalSeconds = _lastValidSeconds;
    }
    setState(() {});
  }

  void _togglePause() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else if (_controller.value > 0 && _controller.value < 1) {
      _controller.forward();
    }
    setState(() {});
  }

  Future<void> _pickTheme() async {
    final picked = await showThemePickerDialog(
      context: context,
      current: _selectedTheme,
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedTheme = picked;
        _sandColor = picked.sandColor;
      });
      widget.onThemeChanged(picked);
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required String label,
  }) {
    return SizedBox(
      width: AppConstants.timeInputWidth,
      child: TextField(
        controller: controller,
        readOnly: _inputLocked,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _controller.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          IconButton(
            tooltip: _isMuted ? AppStrings.tooltipUnmute : AppStrings.tooltipMute,
            onPressed: () => setState(() => _isMuted = !_isMuted),
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
          ),
          IconButton(
            tooltip: AppStrings.tooltipTheme,
            onPressed: _inputLocked ? null : _pickTheme,
            icon: Icon(Icons.palette, color: _sandColor),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: RepaintBoundary(
                    child: AspectRatio(
                      aspectRatio: AppConstants.hourglassAspectRatio,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final s = math.min(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          );
                          return SizedBox(
                            width: s,
                            height: s,
                            child: CustomPaint(
                              painter: HourglassPainter(
                                progress: progress,
                                sandColor: _sandColor,
                                frameColor: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeField(
                    controller: _hoursController,
                    label: AppStrings.fieldHoursLabel,
                  ),
                  const SizedBox(width: AppConstants.timeInputGap),
                  _buildTimeField(
                    controller: _minutesController,
                    label: AppStrings.fieldMinutesLabel,
                  ),
                  const SizedBox(width: AppConstants.timeInputGap),
                  _buildTimeField(
                    controller: _secondsController,
                    label: AppStrings.fieldSecondsLabel,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _canStart ? _start : null,
                    child: const Text(AppStrings.start),
                  ),
                  OutlinedButton(
                    onPressed: _reset,
                    child: const Text(AppStrings.reset),
                  ),
                  OutlinedButton(
                    onPressed: (_controller.value > 0 &&
                            _controller.value < 1)
                        ? _togglePause
                        : null,
                    child: Text(_isPaused ? AppStrings.resume : AppStrings.pause),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.remainingMmSs(formatMmSs(_remainingSeconds)),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
