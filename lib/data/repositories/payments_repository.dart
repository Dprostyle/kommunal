import 'package:flutter/foundation.dart';

import '../../models/payment.dart';
import '../../models/utility_bill.dart';
import '../mock_data.dart';

/// Contract for payment history and mock payment submission.
abstract class PaymentsRepository {
  /// Notifies listeners when history changes (e.g. after a successful payment).
  Listenable get changes;

  Future<List<Payment>> getPayments();

  Future<Payment> payBills(List<UtilityBill> bills);
}

class MockPaymentsRepository implements PaymentsRepository {
  MockPaymentsRepository({List<Payment>? seed})
      : _payments = List<Payment>.from(seed ?? MockData.payments);

  final List<Payment> _payments;
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  @override
  Listenable get changes => _revision;

  @override
  Future<List<Payment>> getPayments() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return List<Payment>.from(_payments)
      ..sort((a, b) => b.paidAt.compareTo(a.paidAt));
  }

  @override
  Future<Payment> payBills(List<UtilityBill> bills) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    if (bills.isEmpty) {
      throw StateError('No bills selected');
    }

    final total = bills.fold<int>(0, (sum, b) => sum + b.amount);
    final payment = Payment(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      paidAt: DateTime.now(),
      amount: total,
      status: PaymentStatus.success,
      serviceTitles: bills.map((b) => b.title).toList(),
      accountNumbers: bills.map((b) => b.accountNumber).toList(),
      transactionId: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
      cardMask: MockData.card.maskedNumber,
    );

    _payments.insert(0, payment);
    _revision.value++;
    return payment;
  }
}
