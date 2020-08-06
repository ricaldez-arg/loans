import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:loans/models/debt/debt.dart';
import 'package:loans/utils/modals/load_spinner.dart';
import 'package:uuid/uuid.dart';

class DebtService {
  DatabaseReference _debtRef;

  DebtService(FirebaseApp app) {
    _debtRef = FirebaseDatabase.instance.reference().child('debts');
  }

  static DatabaseReference getRef() {
    return FirebaseDatabase.instance.reference().child('debts');
  }

  Future<dynamic> createDebt(Debt debt) async {
    try {
      debt.id = Uuid().v1();
      await _debtRef.child(debt.id).set(debt.toJson());
    } catch (e) {
      Future.error('Error');
      print('error $e');
    }
  }

  static dataSnapshotToDebts(DataSnapshot data) {
    List<Debt> debts = [];
    final Map data2 = data.value;
    data2.forEach((key, value) {
      debts.add(Debt.fromJson(value));
    });
    return debts;
  }

  static Future<dynamic> getDebts(context) async {
    showLoadSpinner(context);
    try {
      DataSnapshot data = await getRef().once();
      await Future.delayed(Duration(seconds: 10));
      return dataSnapshotToDebts(data);
    } catch (e) {
      Future.error('Error $e');
    } finally {
      // hideLoadSpinner(context);
    }
  }

  static Future<dynamic> updateDebt(
      context, String debtId, Map<String, dynamic> values) async {
    try {
      final DatabaseReference refDebt = getRef().child(debtId);
      await refDebt.update(values);
    } catch (e) {
      Future.error('Error $e');
    }
  }

  static Future<dynamic> debtListener(context, Function(List<Debt>) handleUpdate) async {
    try {
      getRef().onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        List<Debt> debts = dataSnapshotToDebts(snapshot);
        handleUpdate(debts);
      });
    } catch (e) {
      Future.error('Error $e');
    }
  }
}
