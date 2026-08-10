import 'utility_bill.dart';

/// Linked utility account (personal account / лицевой счёт).
class UtilityAccount {
  const UtilityAccount({
    required this.id,
    required this.type,
    required this.title,
    required this.accountNumber,
  });

  final String id;
  final UtilityServiceType type;
  final String title;
  final String accountNumber;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'accountNumber': accountNumber,
      };

  factory UtilityAccount.fromJson(Map<String, dynamic> json) {
    return UtilityAccount(
      id: json['id'] as String,
      type: UtilityServiceType.values.byName(json['type'] as String),
      title: json['title'] as String,
      accountNumber: json['accountNumber'] as String,
    );
  }
}
