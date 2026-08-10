import 'package:flutter/cupertino.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_dimensions.dart';
import '../app/theme/app_text_styles.dart';

/// Full-width primary CTA used for pay-all and similar actions.
class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon = CupertinoIcons.creditcard,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && !isLoading && onPressed != null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: isEnabled ? 1 : 0.55,
      child: Container(
        height: AppDimensions.ctaHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCta),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: AppDimensions.ctaShadowBlur,
                    offset: const Offset(0, AppDimensions.ctaShadowY),
                  ),
                ]
              : null,
        ),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCta),
          color: AppColors.primary,
          disabledColor: AppColors.primary.withValues(alpha: 0.55),
          onPressed: isEnabled ? onPressed : null,
          child: isLoading
              ? const CupertinoActivityIndicator(
                  color: CupertinoColors.white,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 20, color: CupertinoColors.white),
                    const SizedBox(width: AppDimensions.space8),
                    Text(label, style: AppTextStyles.cta),
                  ],
                ),
        ),
      ),
    );
  }
}
