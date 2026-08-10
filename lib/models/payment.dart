/// Status of a recorded payment.
enum PaymentStatus {
  success,
  failed,
  pending,
}

/// A historical payment record (API-friendly).
class Payment {
  const Payment({
    required this.id,
    required this.paidAt,
    required this.amount,
    required this.status,
    this.currency = 'сум',
    this.serviceTitles = const <String>[],
    this.accountNumbers = const <String>[],
    this.transactionId,
    this.cardMask,
  });

  final String id;
  final DateTime paidAt;
  final int amount;
  final PaymentStatus status;
  final String currency;
  final List<String> serviceTitles;
  final List<String> accountNumbers;
  final String? transactionId;
  final String? cardMask;

  bool get isSuccess => status == PaymentStatus.success;

  Map<String, dynamic> toJson() => {
        'id': id,
        'paidAt': paidAt.toIso8601String(),
        'amount': amount,
        'status': status.name,
        'currency': currency,
        'serviceTitles': serviceTitles,
        'accountNumbers': accountNumbers,
        'transactionId': transactionId,
        'cardMask': cardMask,
      };

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
      amount: json['amount'] as int,
      status: PaymentStatus.values.byName(json['status'] as String),
      currency: json['currency'] as String? ?? 'сум',
      serviceTitles: (json['serviceTitles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      accountNumbers: (json['accountNumbers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      transactionId: json['transactionId'] as String?,
      cardMask: json['cardMask'] as String?,
    );
  }
}
