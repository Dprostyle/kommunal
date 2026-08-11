import 'package:flutter/cupertino.dart';

import '../app/theme/app_dimensions.dart';
import '../app/theme/app_text_styles.dart';
import '../models/utility_bill.dart';
import '../utils/formatters.dart';
import 'app_icon.dart';
import 'section_card.dart';

class UtilityBillCard extends StatelessWidget {
  const UtilityBillCard({
    super.key,
    required this.bill,
  });

  final UtilityBill bill;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppIcon.utility(type: bill.type),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        bill.title,
                        style: AppTextStyles.serviceName,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    Text(
                      formatAmount(bill.amount, currency: bill.currency),
                      style: AppTextStyles.amount,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space4),
                Text(
                  'Лицевой счёт: ${bill.accountNumber}',
                  style: AppTextStyles.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
