import '../../models/payment_card.dart';
import '../../models/utility_account.dart';
import '../mock_data.dart';

/// Profile-related data access. Ready to be replaced with a real API client.
abstract class ProfileRepository {
  Future<PaymentCard> getCard();

  Future<List<UtilityAccount>> getAccounts();

  Future<String> getLanguage();
}

class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository();

  @override
  Future<PaymentCard> getCard() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return MockData.card;
  }

  @override
  Future<List<UtilityAccount>> getAccounts() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return List<UtilityAccount>.from(MockData.accounts);
  }

  @override
  Future<String> getLanguage() async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    return MockData.language;
  }
}
