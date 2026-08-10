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

  void _toggleSelection(String id, bool selected) {
    setState(() {
      _bills = [
        for (final bill in _bills)
          if (bill.id == id) bill.copyWith(isSelected: selected) else bill,
      ];
    });
  }

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
                      AppDimensions.space16,
                      AppDimensions.screenPaddingH,
                      AppDimensions.space32,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const _HomeHeader(),
                        const SizedBox(height: AppDimensions.space24),
                        if (_bills.isEmpty)
                          const SizedBox(
                            height: 280,
                            child: EmptyState(kind: EmptyStateKind.noAccounts),
                          )
                        else ...[
                          for (var i = 0; i < _bills.length; i++) ...[
                            UtilityBillCard(
                              bill: _bills[i],
                              onSelectionChanged: (selected) =>
                                  _toggleSelection(_bills[i].id, selected),
                            ),
                            if (i != _bills.length - 1)
                              const SizedBox(height: AppDimensions.cardGap),
                          ],
                          const SizedBox(height: AppDimensions.sectionGap),
                          _TotalCard(
                            label: 'Итого к оплате:',
                            total: _selectedTotal,
                          ),
                          const SizedBox(height: AppDimensions.cardGap),
                          const _TotalCard(
                            label: 'Баланс на карте:',
                            total: _cardBalance,
                          ),
                          const SizedBox(height: AppDimensions.space20),
                          PaymentButton(
                            label: 'Оплатить всё',
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            'Добро пожаловать!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
              height: 1.2,
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'Уведомления, есть новые',
          child: CupertinoButton(
            padding: const EdgeInsets.all(AppDimensions.space8),
            minimumSize: const Size(
              AppDimensions.minTouchTarget,
              AppDimensions.minTouchTarget,
            ),
            onPressed: () {
              showCupertinoDialog<void>(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Уведомления'),
                  content: const Text('Новых уведомлений нет.'),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: SizedBox(
              width: 28,
              height: 28,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    CupertinoIcons.bell,
                    size: 26,
                    color: AppColors.textPrimary,
                  ),
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.notificationDot,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const int _cardBalance = 500000;

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.label, required this.total});

  final String label;
  final int total;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPadding,
        vertical: AppDimensions.space20,
      ),
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
              style: AppTextStyles.amountLarge,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
