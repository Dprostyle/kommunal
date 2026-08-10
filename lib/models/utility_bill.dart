/// Type of utility service billed to the user.
enum UtilityServiceType {
  electricity,
  gas,
  water,
  garbage,
}

/// A payable utility bill item (API-friendly, UI-independent).
class UtilityBill {
  const UtilityBill({
    required this.id,
    required this.type,
    required this.title,
    required this.accountNumber,
    required this.amount,
    this.currency = 'сум',
    this.isSelected = true,
  });

  final String id;
  final UtilityServiceType type;
  final String title;
  final String accountNumber;
  final int amount;
  final String currency;
  final bool isSelected;

  UtilityBill copyWith({
    String? id,
    UtilityServiceType? type,
    String? title,
    String? accountNumber,
    int? amount,
    String? currency,
    bool? isSelected,
  }) {
    return UtilityBill(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      accountNumber: accountNumber ?? this.accountNumber,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'accountNumber': accountNumber,
        'amount': amount,
        'currency': currency,
        'isSelected': isSelected,
      };

  factory UtilityBill.fromJson(Map<String, dynamic> json) {
    return UtilityBill(
      id: json['id'] as String,
      type: UtilityServiceType.values.byName(json['type'] as String),
      title: json['title'] as String,
      accountNumber: json['accountNumber'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String? ?? 'сум',
      isSelected: json['isSelected'] as bool? ?? true,
    );
  }
}
