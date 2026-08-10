import 'package:flutter/cupertino.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../models/payment.dart';
import '../../../utils/formatters.dart';

class HistoryPaymentRow extends StatelessWidget {
  const HistoryPaymentRow({
    super.key,
    required this.payment,
    required this.onTap,
  });

  final Payment payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSuccess = payment.isSuccess;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.cardPadding,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              width: AppDimensions.historyIconSize,
              height: AppDimensions.historyIconSize,
              decoration: BoxDecoration(
                color: isSuccess
                    ? AppColors.successSoft
                    : AppColors.dangerSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess
                    ? CupertinoIcons.checkmark_alt
                    : CupertinoIcons.xmark,
                size: 18,
                color: isSuccess ? AppColors.success : AppColors.danger,
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatPaymentDateTime(payment.paidAt),
                    style: AppTextStyles.serviceName,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Оплачено: ${formatAmount(payment.amount, currency: payment.currency)}',
                    style: AppTextStyles.secondary,
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
