import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

import '../app/theme/app_colors.dart';

/// YouTube-like arc spinner: half-circle rotating clockwise, slightly faster.
class AppSpinner extends StatefulWidget {
  const AppSpinner({
    super.key,
    this.size = 22,
    this.color,
    this.strokeWidth = 2.6,
  });

  final double size;
  final Color? color;
  final double strokeWidth;

  /// Drop-in builder for [CupertinoSliverRefreshControl].
  static Widget refreshBuilder(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    if (refreshState == RefreshIndicatorMode.inactive) {
      return const SizedBox.shrink();
    }

    final t =
        (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0).toDouble();
    final opacity =
        refreshState == RefreshIndicatorMode.drag ? t : 1.0;

    return Center(
      child: Opacity(
        opacity: opacity,
        child: const AppSpinner(size: 26, color: AppColors.primary),
      ),
    );
  }

  @override
  State<AppSpinner> createState() => _AppSpinnerState();
}

class _AppSpinnerState extends State<AppSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // ~3–4 turns per ~1.6–2.2s; a bit faster than Material/YouTube default.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: CustomPaint(
          painter: _ArcSpinnerPainter(
            color: color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _ArcSpinnerPainter extends CustomPainter {
  _ArcSpinnerPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    // Half-circle arc (YouTube-style incomplete ring).
    canvas.drawArc(rect, -math.pi / 2, math.pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcSpinnerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
