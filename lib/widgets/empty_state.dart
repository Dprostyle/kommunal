import 'package:flutter/cupertino.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_dimensions.dart';
import '../app/theme/app_text_styles.dart';

enum EmptyStateKind {
  emptyHistory,
  noAccounts,
  paymentSuccess,
  paymentFailure,
  loading,
}

/// Reusable empty / feedback states for future API-backed flows.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.kind,
    this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final EmptyStateKind kind;
  final String? title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    if (kind == EmptyStateKind.loading) {
      return const Center(
        child: CupertinoActivityIndicator(radius: 14),
      );
    }

    final config = _configFor(kind);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: config.background,
                shape: BoxShape.circle,
              ),
              child: Icon(config.icon, size: 30, color: config.foreground),
            ),
            const SizedBox(height: AppDimensions.space20),
            Text(
              title ?? config.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyTitle,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              subtitle ?? config.subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptySubtitle,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.space24),
              CupertinoButton.filled(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static _EmptyConfig _configFor(EmptyStateKind kind) {
    switch (kind) {
      case EmptyStateKind.emptyHistory:
        return const _EmptyConfig(
          icon: CupertinoIcons.clock,
          background: AppColors.cardIconBg,
          foreground: AppColors.primary,
          title: 'История пуста',
          subtitle: 'Здесь появятся ваши успешные платежи за коммунальные услуги.',
        );
      case EmptyStateKind.noAccounts:
        return const _EmptyConfig(
          icon: CupertinoIcons.doc_text,
          background: AppColors.accountsIconBg,
          foreground: AppColors.success,
          title: 'Нет лицевых счетов',
          subtitle: 'Добавьте лицевые счета, чтобы оплачивать услуги в один клик.',
        );
      case EmptyStateKind.paymentSuccess:
        return const _EmptyConfig(
          icon: CupertinoIcons.checkmark_alt,
          background: AppColors.successSoft,
          foreground: AppColors.success,
          title: 'Оплата прошла успешно',
          subtitle: 'Средства списаны. Чек сохранён в истории платежей.',
        );
      case EmptyStateKind.paymentFailure:
        return const _EmptyConfig(
          icon: CupertinoIcons.xmark,
          background: AppColors.dangerSoft,
          foreground: AppColors.danger,
          title: 'Не удалось оплатить',
          subtitle: 'Проверьте данные карты и попробуйте ещё раз.',
        );
      case EmptyStateKind.loading:
        return const _EmptyConfig(
          icon: CupertinoIcons.hourglass,
          background: AppColors.background,
          foreground: AppColors.textSecondary,
          title: '',
          subtitle: '',
        );
    }
  }
}

class _EmptyConfig {
  const _EmptyConfig({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final String title;
  final String subtitle;
}
