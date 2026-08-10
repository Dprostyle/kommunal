import 'package:flutter/cupertino.dart';

import 'app_colors.dart';

/// Typography hierarchy aligned with Cupertino / banking-style UIs.
abstract final class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
    height: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static const TextStyle serviceName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static const TextStyle amount = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.2,
  );

  static const TextStyle amountLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
    height: 1.2,
  );

  static const TextStyle secondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle secondarySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle action = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: -0.1,
  );

  static const TextStyle cta = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.white,
    letterSpacing: -0.2,
  );

  static const TextStyle tabLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
  );

  static const TextStyle monthHeader = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: -0.1,
  );

  static const TextStyle danger = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.danger,
    letterSpacing: -0.2,
  );

  static const TextStyle emptyTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle emptySubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}
