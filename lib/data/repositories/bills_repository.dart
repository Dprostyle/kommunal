import '../../models/utility_bill.dart';
import '../mock_data.dart';

/// Contract for loading utility bills. Swap [MockBillsRepository] for an API impl later.
abstract class BillsRepository {
  Future<List<UtilityBill>> getBills();
}

class MockBillsRepository implements BillsRepository {
  const MockBillsRepository();

  @override
  Future<List<UtilityBill>> getBills() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return List<UtilityBill>.from(MockData.bills);
  }
}
