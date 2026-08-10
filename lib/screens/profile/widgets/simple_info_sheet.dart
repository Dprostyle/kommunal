import 'package:flutter/cupertino.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../widgets/payment_button.dart';

Future<void> showSimpleInfoSheet(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showCupertinoModalPopup<void>(
    context: context,
    builder: (context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.separator,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(title, style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppDimensions.space12),
            Text(message, style: AppTextStyles.secondary),
            const SizedBox(height: AppDimensions.space24),
            PaymentButton(
              label: 'Закрыть',
              icon: CupertinoIcons.xmark,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    },
  );
}
