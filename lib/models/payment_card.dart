/// Saved payment card summary for profile display.
class PaymentCard {
  const PaymentCard({
    required this.id,
    required this.maskedNumber,
    required this.brand,
    this.isDefault = true,
  });

  final String id;
  final String maskedNumber;
  final String brand;
  final bool isDefault;

  Map<String, dynamic> toJson() => {
        'id': id,
        'maskedNumber': maskedNumber,
        'brand': brand,
        'isDefault': isDefault,
      };

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      id: json['id'] as String,
      maskedNumber: json['maskedNumber'] as String,
      brand: json['brand'] as String,
      isDefault: json['isDefault'] as bool? ?? true,
    );
  }
}
