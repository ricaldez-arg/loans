import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:loans/models/debt/debt.dart';
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

  static Future<dynamic> getDebts(context) async {
    try {
      DataSnapshot data = await getRef().once();
      List debts = [];
      final Map data2 = data.value;
      data2.forEach((key, value) {
        debts.add(Debt.fromJson(value));
      });
      return debts;
    } catch (e) {
      Future.error('Error $e');
    }
  }
}
