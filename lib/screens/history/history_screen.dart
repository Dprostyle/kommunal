import 'package:flutter/cupertino.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/repositories/payments_repository.dart';
import '../../models/payment.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_card.dart';
import 'payment_details_screen.dart';
import 'widgets/history_payment_row.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    required this.paymentsRepository,
  });

  final PaymentsRepository paymentsRepository;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Payment> _payments = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    widget.paymentsRepository.changes.addListener(_onPaymentsChanged);
  }

  @override
  void dispose() {
    widget.paymentsRepository.changes.removeListener(_onPaymentsChanged);
    super.dispose();
  }

  void _onPaymentsChanged() {
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final payments = await widget.paymentsRepository.getPayments();
      if (!mounted) return;
      setState(() {
        _payments = payments;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _payments = const [];
        _loading = false;
      });
    }
  }

  Map<String, List<Payment>> _groupByMonth(List<Payment> payments) {
    final groups = <String, List<Payment>>{};
    for (final payment in payments) {
      final key = formatMonthYear(payment.paidAt);
      groups.putIfAbsent(key, () => <Payment>[]).add(payment);
    }
    return groups;
  }

  void _openDetails(Payment payment) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) => PaymentDetailsScreen(payment: payment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupByMonth(_payments);

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
                  CupertinoSliverRefreshControl(onRefresh: _load),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPaddingH,
                      AppDimensions.space16,
                      AppDimensions.screenPaddingH,
                      AppDimensions.space32,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const Text('История', style: AppTextStyles.screenTitle),
                        const SizedBox(height: AppDimensions.space24),
                        if (_payments.isEmpty)
                          const SizedBox(
                            height: 320,
                            child: EmptyState(
                              kind: EmptyStateKind.emptyHistory,
                            ),
                          )
                        else
                          for (final entry in groups.entries) ...[
                            Text(entry.key, style: AppTextStyles.monthHeader),
                            const SizedBox(height: AppDimensions.space12),
                            SectionCard(
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  for (var i = 0;
                                      i < entry.value.length;
                                      i++) ...[
                                    HistoryPaymentRow(
                                      payment: entry.value[i],
                                      onTap: () =>
                                          _openDetails(entry.value[i]),
                                    ),
                                    if (i != entry.value.length - 1)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 64),
                                        child: ColoredBox(
                                          color: AppColors.separator,
                                          child: SizedBox(
                                            height: 0.5,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: AppDimensions.sectionGap),
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
