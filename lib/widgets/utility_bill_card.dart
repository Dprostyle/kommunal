import 'package:flutter/cupertino.dart';

import '../app/theme/app_colors.dart';
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
    this.isSelected = false,
    this.onTap,
  });

  static const Color _selectedColor = Color(0xFFCBDDF5);

  final UtilityBill bill;
  final bool isSelected;
  final VoidCallback? onTap;

  bool get _isDebt =>
      bill.type == UtilityServiceType.electricity ||
      bill.type == UtilityServiceType.gas;

  @override
  Widget build(BuildContext context) {
    final amountLabel = formatAmount(
      _isDebt ? -bill.amount : bill.amount,
      currency: bill.currency,
    );
    final amountColor = _isDebt ? AppColors.danger : AppColors.credit;

    return SectionCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: isSelected ? _selectedColor : AppColors.card,
      border: null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppIcon.utility(type: bill.type),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bill.title,
                  style: AppTextStyles.serviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  'Лицевой счёт: ${bill.accountNumber}',
                  style: AppTextStyles.secondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          Text(
            amountLabel,
            style: AppTextStyles.amount.copyWith(color: amountColor),
          ),
        ],
      ),
    );
  }
}
