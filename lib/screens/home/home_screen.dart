import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/repositories/bills_repository.dart';
import '../../data/repositories/payments_repository.dart';
import '../../models/utility_bill.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_spinner.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/utility_bill_card.dart';
import '../profile/widgets/simple_info_sheet.dart';
import 'widgets/payment_result_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.billsRepository,
    required this.paymentsRepository,
  });

  final BillsRepository billsRepository;
  final PaymentsRepository paymentsRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UtilityBill> _bills = const [];
  bool _loading = true;
  bool _paying = false;
  String? _selectedBillId;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
    _loadBills();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadBills() async {
    setState(() => _loading = true);
    try {
      final bills = await widget.billsRepository.getBills();
      if (!mounted) return;
      setState(() {
        _bills = bills;
        _loading = false;
        _selectedBillId ??= bills.isNotEmpty ? bills.first.id : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _bills = const [];
        _loading = false;
      });
    }
  }

  UtilityBill? get _selectedBill {
    final id = _selectedBillId;
    if (id == null) return null;
    for (final bill in _bills) {
      if (bill.id == id) return bill;
    }
    return null;
  }

  int? get _enteredAmount {
    final text = _amountController.text.replaceAll(RegExp(r'\s'), '');
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  static const int _minPaymentAmount = 1000;

  bool get _canPay {
    final amount = _enteredAmount;
    return _selectedBill != null &&
        amount != null &&
        amount >= _minPaymentAmount &&
        !_paying;
  }

  void _selectBill(String billId) {
    HapticFeedback.mediumImpact();
    setState(() => _selectedBillId = billId);
  }

  Future<void> _paySelected() async {
    final bill = _selectedBill;
    final amount = _enteredAmount;
    if (bill == null ||
        amount == null ||
        amount < _minPaymentAmount ||
        _paying) {
      return;
    }

    final billToPay = bill.copyWith(amount: amount);
    setState(() => _paying = true);

    try {
      final payment = await widget.paymentsRepository.payBills([billToPay]);
      if (!mounted) return;
      await showPaymentResultSheet(
        context,
        success: true,
        amountLabel: formatAmount(payment.amount),
      );
    } catch (_) {
      if (!mounted) return;
      await showPaymentResultSheet(
        context,
        success: false,
        amountLabel: formatAmount(amount),
      );
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: _loading
            ? const EmptyState(kind: EmptyStateKind.loading)
            : CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _loadBills,
                    builder: AppSpinner.refreshBuilder,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPaddingH,
                      AppDimensions.space8,
                      AppDimensions.screenPaddingH,
                      AppDimensions.space12,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const _CompactBalanceCard(),
                        const SizedBox(height: AppDimensions.space12),
                        if (_bills.isEmpty)
                          const SizedBox(
                            height: 280,
                            child: EmptyState(kind: EmptyStateKind.noAccounts),
                          )
                        else ...[
                          for (var i = 0; i < _bills.length; i++) ...[
                            UtilityBillCard(
                              bill: _bills[i],
                              isSelected: _bills[i].id == _selectedBillId,
                              onTap: () => _selectBill(_bills[i].id),
                            ),
                            if (i != _bills.length - 1)
                              const SizedBox(height: AppDimensions.cardGap),
                          ],
                          const SizedBox(height: AppDimensions.cardGap),
                          _PaymentInputCard(
                            label: _paymentLabelFor(_selectedBill?.type),
                            controller: _amountController,
                            enabled: _canPay,
                            isLoading: _paying,
                            onPressed: _paySelected,
                          ),
                        ],
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Premium bank-card style balance summary — visually distinct from service rows.
class _CompactBalanceCard extends StatelessWidget {
  const _CompactBalanceCard();

  static const int _balance = 500000;
  static const String _maskedNumber = '•••• 4567';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showSimpleInfoSheet(
        context,
        title: 'Баланс на карте',
        message: '$_maskedNumber\n${formatAmount(_balance)}',
      ),
      child: Container(
        height: 148,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: const Color(0xFF043A8C).withValues(alpha: 0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Saturated blue gradient surface
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A7CFF),
                      Color(0xFF0A6CFF),
                      Color(0xFF0652C7),
                    ],
                    stops: [0.0, 0.45, 1.0],
                  ),
                ),
                child: SizedBox.expand(),
              ),
              // Soft glass highlight
              Positioned(
                top: -40,
                left: -20,
                child: Container(
                  width: 160,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CupertinoColors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
              // Decorative mini card (rotated, clipped by parent)
              const Positioned(
                right: -28,
                bottom: -18,
                child: _DecorativeBankCard(),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: CupertinoColors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            CupertinoIcons.creditcard_fill,
                            size: 18,
                            color: CupertinoColors.white.withValues(alpha: 0.95),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Баланс на карте',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.white,
                                  letterSpacing: -0.2,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                _maskedNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xB3FFFFFF),
                                  letterSpacing: 0.6,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: CupertinoColors.white.withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            CupertinoIcons.right_chevron,
                            size: 14,
                            color: CupertinoColors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Доступно',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: CupertinoColors.white.withValues(alpha: 0.7),
                        letterSpacing: -0.1,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatAmount(_balance),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: CupertinoColors.white,
                        letterSpacing: -0.6,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Semi-transparent stylized card silhouette for premium depth.
class _DecorativeBankCard extends StatelessWidget {
  const _DecorativeBankCard();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.28,
      child: Opacity(
        opacity: 0.28,
        child: Container(
          width: 118,
          height: 74,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFB8D4FF),
              ],
            ),
            border: Border.all(
              color: CupertinoColors.white.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF043A8C).withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const Spacer(),
              Container(
                height: 5,
                width: 56,
                decoration: BoxDecoration(
                  color: CupertinoColors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 4,
                width: 36,
                decoration: BoxDecoration(
                  color: CupertinoColors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _paymentLabelFor(UtilityServiceType? type) {
  return switch (type) {
    UtilityServiceType.electricity => 'Оплата за электричество:',
    UtilityServiceType.gas => 'Оплата за газ:',
    UtilityServiceType.water => 'Оплата за воду:',
    UtilityServiceType.garbage => 'Оплата за вывоз мусора:',
    UtilityServiceType.phone => 'Оплата за телефон:',
    UtilityServiceType.internet => 'Оплата за интернет:',
    null => null,
  };
}

class _PaymentInputCard extends StatefulWidget {
  const _PaymentInputCard({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.isLoading,
    required this.onPressed,
  });

  final String? label;
  final TextEditingController controller;
  final bool enabled;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  State<_PaymentInputCard> createState() => _PaymentInputCardState();
}

class _PaymentInputCardState extends State<_PaymentInputCard> {
  static const Color _disabledBg = Color(0xFFE8F1FF);
  static const Color _disabledText = Color(0xFF9DBCF0);

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isActionEnabled =>
      widget.enabled && !widget.isLoading && widget.onPressed != null;

  Widget _buildPayButton({bool ghost = false}) {
    return IgnorePointer(
      ignoring: ghost,
      child: Opacity(
        opacity: ghost ? 0 : 1,
        child: GestureDetector(
          onTap: ghost || !_isActionEnabled
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  widget.onPressed!();
                },
          child: Container(
            height: AppDimensions.minTouchTarget,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
            ),
            decoration: BoxDecoration(
              color: _isActionEnabled ? AppColors.primary : _disabledBg,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: widget.isLoading ? 0 : 1,
                  child: Text(
                    "To'lash",
                    style: AppTextStyles.cta.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _isActionEnabled
                          ? CupertinoColors.white
                          : _disabledText,
                    ),
                  ),
                ),
                if (!ghost && widget.isLoading)
                  const AppSpinner(
                    size: 20,
                    color: CupertinoColors.white,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _focusNode.hasFocus
        ? AppColors.primary
        : AppColors.primary.withValues(alpha: 0.65);
    final borderWidth = _focusNode.hasFocus ? 1.5 : 1.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: AppDimensions.minTouchTarget),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Text(
                  widget.label!,
                  style: AppTextStyles.secondary,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              Opacity(
                opacity: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                  ),
                  child: Text(
                    "To'lash",
                    style: AppTextStyles.cta.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.cardGap),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/1.png',
                width: AppDimensions.minTouchTarget,
                height: AppDimensions.minTouchTarget,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: SizedBox(
                height: AppDimensions.minTouchTarget,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CupertinoTextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      placeholder: "To'lov qilish",
                      placeholderStyle: AppTextStyles.amount.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: 1.0,
                      ),
                      style: AppTextStyles.amount.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.0,
                      ),
                      cursorColor: AppColors.primary,
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.space12,
                        0,
                        44,
                        0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(
                          color: borderColor,
                          width: borderWidth,
                        ),
                      ),
                    ),
                    Positioned(
                      right: AppDimensions.space12,
                      child: Text(
                        'Сум',
                        style: AppTextStyles.amount.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            _buildPayButton(),
          ],
        ),
      ],
    );
  }
}
