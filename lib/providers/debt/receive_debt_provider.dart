import 'package:flutter/widgets.dart';
import 'package:loans/models/debt/debt.dart';
import 'package:loans/services/user_service/debt_service.dart';

class ReceiveDebtProvider with ChangeNotifier {
  List<Debt> _debts = [];

  get debts => _debts;

  handleUpdate(List<Debt> updatedDetbs) {
    _debts = updatedDetbs;
    notifyListeners();
  }

  // loadDebts(context) async {
  //   DebtService.debtListener(context, handleUpdate);
  // }

  loadDebts(context) async {
    final newDebts = await DebtService.getDebts(context);
    if (newDebts is List<Debt>) {
      _debts = newDebts;
      _debts.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt);
      });
    }
    DebtService.debtListener(context, handleUpdate);
    notifyListeners();
  }

  addPayment(context, currentDebt, num amount) {
    final payments = currentDebt.payments;
    payments.add(Payment(DateTime.now(), amount));
    currentDebt.updates.add(DateTime.now());
    DebtService.updateDebt(context, currentDebt.id, {
      'payments': currentDebt.paymentsToJson(),
      'updates': currentDebt.updatesToJson()
    });
  }
}
