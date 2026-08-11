import 'package:flutter/cupertino.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/repositories/bills_repository.dart';
import '../../data/repositories/payments_repository.dart';
import '../../models/utility_bill.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_spinner.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/payment_button.dart';
import '../../widgets/section_card.dart';
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

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    setState(() => _loading = true);
    try {
      final bills = await widget.billsRepository.getBills();
      if (!mounted) return;
      setState(() {
        _bills = bills;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _bills = const [];
        _loading = false;
      });
    }
  }

  int get _selectedTotal => _bills
      .where((b) => b.isSelected)
      .fold<int>(0, (sum, b) => sum + b.amount);

  List<UtilityBill> get _selectedBills =>
      _bills.where((b) => b.isSelected).toList();

  Future<void> _paySelected() async {
    final bills = _selectedBills;
    if (bills.isEmpty || _paying) return;

    setState(() => _paying = true);

    try {
      final payment = await widget.paymentsRepository.payBills(bills);
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
        amountLabel: formatAmount(
          bills.fold<int>(0, (sum, b) => sum + b.amount),
        ),
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
                            UtilityBillCard(bill: _bills[i]),
                            if (i != _bills.length - 1)
                              const SizedBox(height: AppDimensions.cardGap),
                          ],
                          const SizedBox(height: AppDimensions.sectionGap),
                          _TotalCard(
                            label: 'Итого к оплате:',
                            total: _selectedTotal,
                          ),
                          const SizedBox(height: AppDimensions.space12),
                          PaymentButton(
                            label: 'Оплатить',
                            isLoading: _paying,
                            enabled: _selectedBills.isNotEmpty,
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

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.label, required this.total});

  final String label;
  final int total;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPadding,
        vertical: AppDimensions.space12,
      ),
      showShadow: false,
      border: Border.all(color: AppColors.separator),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.sectionTitle),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  ...previousChildren,
                  ?currentChild,
                ],
              );
            },
            child: Text(
              formatAmount(total),
              key: ValueKey('$label-$total'),
              style: AppTextStyles.amountLarge.copyWith(fontSize: 18),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
