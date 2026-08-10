import 'package:flutter/cupertino.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_dimensions.dart';
import '../models/utility_bill.dart';

/// Soft pastel rounded-square icon used for utilities and profile rows.
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.child,
    this.size = AppDimensions.serviceIconSize,
    this.iconSize,
    this.borderRadius = AppDimensions.radiusIcon,
  });

  factory AppIcon.utility({
    Key? key,
    required UtilityServiceType type,
    double size = AppDimensions.serviceIconSize,
  }) {
    switch (type) {
      case UtilityServiceType.electricity:
        return AppIcon(
          key: key,
          size: size,
          backgroundColor: AppColors.electricityBg,
          foregroundColor: AppColors.electricityFg,
          child: const _BoltIcon(),
        );
      case UtilityServiceType.gas:
        return AppIcon(
          key: key,
          size: size,
          backgroundColor: AppColors.gasBg,
          foregroundColor: AppColors.gasFg,
          child: const _FlameIcon(),
        );
      case UtilityServiceType.water:
        return AppIcon(
          key: key,
          size: size,
          backgroundColor: AppColors.waterBg,
          foregroundColor: AppColors.waterFg,
          child: const Icon(CupertinoIcons.drop_fill, size: 22),
        );
      case UtilityServiceType.garbage:
        return AppIcon(
          key: key,
          size: size,
          backgroundColor: AppColors.garbageBg,
          foregroundColor: AppColors.garbageFg,
          child: const _LeafIcon(),
        );
    }
  }

  final Color backgroundColor;
  final Color foregroundColor;
  final Widget child;
  final double size;
  final double? iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: IconTheme(
        data: IconThemeData(
          color: foregroundColor,
          size: iconSize ?? size * 0.5,
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: foregroundColor),
          child: child,
        ),
      ),
    );
  }
}

class _BoltIcon extends StatelessWidget {
  const _BoltIcon();

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color ?? AppColors.electricityFg;
    return CustomPaint(
      size: const Size(18, 22),
      painter: _BoltPainter(color),
    );
  }
}

class _BoltPainter extends CustomPainter {
  _BoltPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.58, 0)
      ..lineTo(size.width * 0.18, size.height * 0.55)
      ..lineTo(size.width * 0.48, size.height * 0.55)
      ..lineTo(size.width * 0.38, size.height)
      ..lineTo(size.width * 0.82, size.height * 0.42)
      ..lineTo(size.width * 0.52, size.height * 0.42)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BoltPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _FlameIcon extends StatelessWidget {
  const _FlameIcon();

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color ?? AppColors.gasFg;
    return CustomPaint(
      size: const Size(16, 22),
      painter: _FlamePainter(color),
    );
  }
}

class _FlamePainter extends CustomPainter {
  _FlamePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.28,
        size.width,
        size.height * 0.42,
        size.width * 0.92,
        size.height * 0.68,
      )
      ..cubicTo(
        size.width * 0.86,
        size.height * 0.92,
        size.width * 0.64,
        size.height,
        size.width * 0.5,
        size.height,
      )
      ..cubicTo(
        size.width * 0.36,
        size.height,
        size.width * 0.14,
        size.height * 0.92,
        size.width * 0.08,
        size.height * 0.68,
      )
      ..cubicTo(
        0,
        size.height * 0.42,
        size.width * 0.22,
        size.height * 0.28,
        size.width * 0.5,
        0,
      )
      ..close();

    canvas.drawPath(path, paint);

    final inner = Paint()
      ..color = Color.lerp(color, const Color(0xFFFFFFFF), 0.35)!
      ..style = PaintingStyle.fill;

    final innerPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.38)
      ..cubicTo(
        size.width * 0.64,
        size.height * 0.5,
        size.width * 0.68,
        size.height * 0.62,
        size.width * 0.58,
        size.height * 0.78,
      )
      ..cubicTo(
        size.width * 0.54,
        size.height * 0.86,
        size.width * 0.46,
        size.height * 0.86,
        size.width * 0.42,
        size.height * 0.78,
      )
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.62,
        size.width * 0.36,
        size.height * 0.5,
        size.width * 0.5,
        size.height * 0.38,
      )
      ..close();

    canvas.drawPath(innerPath, inner);
  }

  @override
  bool shouldRepaint(covariant _FlamePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _LeafIcon extends StatelessWidget {
  const _LeafIcon();

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color ?? AppColors.garbageFg;
    return CustomPaint(
      size: const Size(20, 20),
      painter: _LeafPainter(color),
    );
  }
}

class _LeafPainter extends CustomPainter {
  _LeafPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.05,
        size.height * 0.35,
        size.width * 0.55,
        size.height * 0.08,
      )
      ..quadraticBezierTo(
        size.width * 1.02,
        size.height * 0.35,
        size.width * 0.72,
        size.height * 0.88,
      )
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 1.0,
        size.width * 0.15,
        size.height * 0.85,
      )
      ..close();

    canvas.drawPath(path, fill);

    final stem = Paint()
      ..color = Color.lerp(color, const Color(0xFFFFFFFF), 0.35)!
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.78),
      Offset(size.width * 0.68, size.height * 0.28),
      stem,
    );
  }

  @override
  bool shouldRepaint(covariant _LeafPainter oldDelegate) =>
      oldDelegate.color != color;
}
