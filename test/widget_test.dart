import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';

import 'package:communal/app/app.dart';
import 'package:communal/data/repositories/bills_repository.dart';
import 'package:communal/data/repositories/payments_repository.dart';
import 'package:communal/data/repositories/profile_repository.dart';
import 'package:communal/models/payment.dart';
import 'package:communal/models/payment_card.dart';
import 'package:communal/models/utility_account.dart';
import 'package:communal/models/utility_bill.dart';

class _ImmediateBillsRepository implements BillsRepository {
  @override
  Future<List<UtilityBill>> getBills() async => const [
        UtilityBill(
          id: '1',
          type: UtilityServiceType.electricity,
          title: 'Электричество',
          accountNumber: '100245874',
          amount: 45200,
        ),
        UtilityBill(
          id: '2',
          type: UtilityServiceType.gas,
          title: 'Газ',
          accountNumber: '200157231',
          amount: 56300,
        ),
      ];
}

class _ImmediatePaymentsRepository implements PaymentsRepository {
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  @override
  Listenable get changes => _revision;

  @override
  Future<List<Payment>> getPayments() async => [
        Payment(
          id: 'p1',
          paidAt: DateTime(2024, 7, 15, 10, 30),
          amount: 145600,
          status: PaymentStatus.success,
        ),
      ];

  @override
  Future<Payment> payBills(List<UtilityBill> bills) async {
    _revision.value++;
    return Payment(
      id: 'new',
      paidAt: DateTime(2024, 7, 15, 10, 30),
      amount: bills.fold(0, (s, b) => s + b.amount),
      status: PaymentStatus.success,
    );
  }
}

class _ImmediateProfileRepository implements ProfileRepository {
  @override
  Future<List<UtilityAccount>> getAccounts() async => const [
        UtilityAccount(
          id: 'a1',
          type: UtilityServiceType.electricity,
          title: 'Электричество',
          accountNumber: '100245874',
        ),
      ];

  @override
  Future<PaymentCard> getCard() async => const PaymentCard(
        id: 'c1',
        maskedNumber: '8600 **** **** 1234',
        brand: 'Uzcard',
      );

  @override
  Future<String> getLanguage() async => 'Русский';
}

void main() {
  testWidgets('renders home greeting and tabs', (tester) async {
    await tester.pumpWidget(
      CommunalApp(
        billsRepository: _ImmediateBillsRepository(),
        paymentsRepository: _ImmediatePaymentsRepository(),
        profileRepository: _ImmediateProfileRepository(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Баланс на карте'), findsOneWidget);
    expect(find.text('Главная'), findsWidgets);
    expect(find.text('История'), findsWidgets);
    expect(find.text('Профиль'), findsWidgets);
    expect(find.text('Электричество'), findsOneWidget);
    expect(find.text('101 500 сум'), findsOneWidget);
  });
}
