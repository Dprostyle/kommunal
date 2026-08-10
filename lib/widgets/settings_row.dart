import 'package:flutter/cupertino.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_dimensions.dart';
import '../app/theme/app_text_styles.dart';
import 'app_icon.dart';

/// Profile / settings list row with soft icon, title, subtitle, and chevron.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
    this.showSeparator = true,
    this.isDestructive = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback onTap;
  final bool showSeparator;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.cardPadding,
              vertical: 14,
            ),
            child: Row(
              children: [
                AppIcon(
                  size: AppDimensions.profileIconSize,
                  backgroundColor: iconBackground,
                  foregroundColor: iconColor,
                  child: Icon(icon, size: 20),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: isDestructive
                            ? AppTextStyles.danger
                            : AppTextStyles.serviceName,
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(subtitle, style: AppTextStyles.secondary),
                      ],
                    ],
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 18,
                  color: isDestructive
                      ? AppColors.danger.withValues(alpha: 0.55)
                      : AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        if (showSeparator)
          const Padding(
            padding: EdgeInsets.only(left: 68),
            child: ColoredBox(
              color: AppColors.separator,
              child: SizedBox(height: 0.5, width: double.infinity),
            ),
          ),
      ],
    );
  }
}
