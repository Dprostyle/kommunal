import 'package:flutter/cupertino.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_dimensions.dart';

/// Animated selection checkbox with filled blue selected state.
class SelectionCheckbox extends StatelessWidget {
  const SelectionCheckbox({
    super.key,
    required this.selected,
    this.onChanged,
    this.size = AppDimensions.checkboxSize,
  });

  final bool selected;
  final ValueChanged<bool>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: selected,
      button: true,
      label: selected ? 'Выбрано' : 'Не выбрано',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : () => onChanged!(!selected),
        child: SizedBox(
          width: AppDimensions.minTouchTarget,
          height: AppDimensions.minTouchTarget,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.card,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.checkboxBorder,
                  width: 1.5,
                ),
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 140),
                opacity: selected ? 1 : 0,
                child: const Icon(
                  CupertinoIcons.checkmark_alt,
                  size: 16,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
