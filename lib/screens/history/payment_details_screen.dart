import 'package:flutter/cupertino.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import '../../models/payment.dart';
import '../../utils/formatters.dart';
import '../../widgets/section_card.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({
    super.key,
    required this.payment,
  });

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: Text('Детали платежа'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.screenPaddingH,
            AppDimensions.space16,
            AppDimensions.screenPaddingH,
            AppDimensions.space32,
          ),
          children: [
            SectionCard(
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: payment.isSuccess
                          ? AppColors.successSoft
                          : AppColors.dangerSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      payment.isSuccess
                          ? CupertinoIcons.checkmark_alt
                          : CupertinoIcons.xmark,
                      color: payment.isSuccess
                          ? AppColors.success
                          : AppColors.danger,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),
                  Text(
                    formatAmount(payment.amount, currency: payment.currency),
                    style: AppTextStyles.amountLarge,
                  ),
                  const SizedBox(height: AppDimensions.space4),
                  Text(
                    payment.isSuccess ? 'Успешно оплачено' : 'Ошибка оплаты',
                    style: AppTextStyles.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.cardGap),
            SectionCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Дата',
                    value: formatPaymentDateTime(payment.paidAt),
                  ),
                  const _DetailDivider(),
                  _DetailRow(
                    label: 'Статус',
                    value: payment.isSuccess ? 'Оплачено' : 'Ошибка',
                  ),
                  if (payment.transactionId != null) ...[
                    const _DetailDivider(),
                    _DetailRow(
                      label: 'ID транзакции',
                      value: payment.transactionId!,
                    ),
                  ],
                  if (payment.cardMask != null) ...[
                    const _DetailDivider(),
                    _DetailRow(
                      label: 'Карта',
                      value: payment.cardMask!,
                    ),
                  ],
                  if (payment.serviceTitles.isNotEmpty) ...[
                    const _DetailDivider(),
                    _DetailRow(
                      label: 'Услуги',
                      value: payment.serviceTitles.join(', '),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPadding,
        vertical: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTextStyles.secondary),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.serviceName,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: AppDimensions.cardPadding),
      child: ColoredBox(
        color: AppColors.separator,
        child: SizedBox(height: 0.5, width: double.infinity),
      ),
    );
  }
}
