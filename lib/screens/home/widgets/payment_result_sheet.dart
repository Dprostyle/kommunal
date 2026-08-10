import 'package:flutter/cupertino.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/payment_button.dart';

Future<void> showPaymentResultSheet(
  BuildContext context, {
  required bool success,
  required String amountLabel,
}) {
  return showCupertinoModalPopup<void>(
    context: context,
    builder: (context) => PaymentResultSheet(
      success: success,
      amountLabel: amountLabel,
    ),
  );
}

class PaymentResultSheet extends StatelessWidget {
  const PaymentResultSheet({
    super.key,
    required this.success,
    required this.amountLabel,
  });

  final bool success;
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppDimensions.screenPaddingH,
        AppDimensions.space24,
        AppDimensions.screenPaddingH,
        AppDimensions.space20 + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusCard),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.separator,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppDimensions.space24),
          EmptyState(
            kind: success
                ? EmptyStateKind.paymentSuccess
                : EmptyStateKind.paymentFailure,
            subtitle: success
                ? 'Сумма $amountLabel успешно оплачена. Детали доступны в разделе «История».'
                : 'Платёж на сумму $amountLabel не выполнен. Попробуйте снова.',
          ),
          const SizedBox(height: AppDimensions.space24),
          PaymentButton(
            label: 'Готово',
            icon: CupertinoIcons.checkmark_alt,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
