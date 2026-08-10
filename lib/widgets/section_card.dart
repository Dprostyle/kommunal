import 'package:flutter/cupertino.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_dimensions.dart';

/// Elevated white surface used for grouped content blocks.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.cardPadding),
    this.margin,
    this.onTap,
    this.backgroundColor = AppColors.card,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: showShadow
            ? const [
                BoxShadow(
                  color: Color(0x0A111827),
                  blurRadius: AppDimensions.cardShadowBlur,
                  offset: Offset(0, AppDimensions.cardShadowY),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap == null) return card;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: card,
    );
  }
}
