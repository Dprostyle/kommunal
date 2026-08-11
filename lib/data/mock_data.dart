import '../models/payment.dart';
import '../models/payment_card.dart';
import '../models/utility_account.dart';
import '../models/utility_bill.dart';

/// Static mock dataset. Replace repository implementations later with API calls.
abstract final class MockData {
  static const List<UtilityBill> bills = [
    UtilityBill(
      id: 'bill_electricity',
      type: UtilityServiceType.electricity,
      title: 'Электричество',
      accountNumber: '100245874',
      amount: 45200,
    ),
    UtilityBill(
      id: 'bill_gas',
      type: UtilityServiceType.gas,
      title: 'Газ',
      accountNumber: '200157231',
      amount: 56300,
    ),
    UtilityBill(
      id: 'bill_water',
      type: UtilityServiceType.water,
      title: 'Вода',
      accountNumber: '300259741',
      amount: 18000,
    ),
    UtilityBill(
      id: 'bill_garbage',
      type: UtilityServiceType.garbage,
      title: 'Мусор',
      accountNumber: '400369852',
      amount: 26100,
    ),
    UtilityBill(
      id: 'bill_phone',
      type: UtilityServiceType.phone,
      title: 'Телефон',
      accountNumber: '500478963',
      amount: 35000,
    ),
    UtilityBill(
      id: 'bill_internet',
      type: UtilityServiceType.internet,
      title: 'Интернет',
      accountNumber: '600589741',
      amount: 89000,
    ),
  ];

  static const List<UtilityAccount> accounts = [
    UtilityAccount(
      id: 'acc_1',
      type: UtilityServiceType.electricity,
      title: 'Электричество',
      accountNumber: '100245874',
    ),
    UtilityAccount(
      id: 'acc_2',
      type: UtilityServiceType.gas,
      title: 'Газ',
      accountNumber: '200157231',
    ),
    UtilityAccount(
      id: 'acc_3',
      type: UtilityServiceType.water,
      title: 'Вода',
      accountNumber: '300259741',
    ),
    UtilityAccount(
      id: 'acc_4',
      type: UtilityServiceType.garbage,
      title: 'Мусор',
      accountNumber: '400369852',
    ),
    UtilityAccount(
      id: 'acc_5',
      type: UtilityServiceType.phone,
      title: 'Телефон',
      accountNumber: '500478963',
    ),
    UtilityAccount(
      id: 'acc_6',
      type: UtilityServiceType.internet,
      title: 'Интернет',
      accountNumber: '600589741',
    ),
  ];

  static const PaymentCard card = PaymentCard(
    id: 'card_1',
    maskedNumber: '8600 **** **** 1234',
    brand: 'Uzcard',
  );

  static const String language = 'Русский';

  /// Reference "today" for stable mock relative labels (Июль 2024).
  static final DateTime mockNow = DateTime(2024, 7, 15, 10, 30);

  static final List<Payment> payments = [
    Payment(
      id: 'pay_1',
      paidAt: DateTime(2024, 7, 15, 10, 30),
      amount: 145600,
      status: PaymentStatus.success,
      serviceTitles: const [
        'Электричество',
        'Газ',
        'Вода',
        'Мусор',
      ],
      accountNumbers: const [
        '100245874',
        '200157231',
        '300259741',
        '400369852',
      ],
      transactionId: 'TXN-240715-1030',
      cardMask: '8600 **** **** 1234',
    ),
    Payment(
      id: 'pay_2',
      paidAt: DateTime(2024, 7, 5, 11, 15),
      amount: 112000,
      status: PaymentStatus.success,
      serviceTitles: const ['Электричество', 'Газ', 'Вода'],
      accountNumbers: const ['100245874', '200157231', '300259741'],
      transactionId: 'TXN-240705-1115',
      cardMask: '8600 **** **** 1234',
    ),
    Payment(
      id: 'pay_3',
      paidAt: DateTime(2024, 6, 28, 9, 40),
      amount: 98500,
      status: PaymentStatus.success,
      serviceTitles: const ['Электричество', 'Газ'],
      accountNumbers: const ['100245874', '200157231'],
      transactionId: 'TXN-240628-0940',
      cardMask: '8600 **** **** 1234',
    ),
    Payment(
      id: 'pay_4',
      paidAt: DateTime(2024, 6, 20, 14, 20),
      amount: 105300,
      status: PaymentStatus.success,
      serviceTitles: const ['Электричество', 'Газ', 'Мусор'],
      accountNumbers: const ['100245874', '200157231', '400369852'],
      transactionId: 'TXN-240620-1420',
      cardMask: '8600 **** **** 1234',
    ),
    Payment(
      id: 'pay_5',
      paidAt: DateTime(2024, 6, 10, 10, 10),
      amount: 124000,
      status: PaymentStatus.success,
      serviceTitles: const [
        'Электричество',
        'Газ',
        'Вода',
        'Мусор',
      ],
      accountNumbers: const [
        '100245874',
        '200157231',
        '300259741',
        '400369852',
      ],
      transactionId: 'TXN-240610-1010',
      cardMask: '8600 **** **** 1234',
    ),
  ];
}
