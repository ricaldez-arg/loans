import 'package:flutter/material.dart';
import 'package:loans/models/debt/debt.dart';
import 'package:loans/models/enums.dart';
import 'package:loans/providers/session/session_provider.dart';
import 'package:loans/services/user_service/debt_service.dart';
import 'package:loans/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';

class NewDebtProvider with ChangeNotifier {
  bool _isCreditor = true;
  Periodicity _periodicity = Periodicity.annually;
  Periodicity _paymentPeriod = Periodicity.once;
  Coin _selectedCoin = Coin.bs;
  String _amount;
  String _interest = '0';
  String _name;
  DateTime _selectedDateTime;
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);
  int _selectedDay = 1;
  Days _selectedDayOfWeek = Days.friday;
  bool _periodValid;

  DebtService _debtService;
  String _errorMessage = '';

  NewDebtProvider(FirebaseApp app) {
    _debtService = DebtService(app);
  }
  get errorMessage => _errorMessage;

  get name => _name;
  get isCreditor => _isCreditor;
  get periodicity => _periodicity;
  get paymentPeriod => _paymentPeriod;
  get selectedCoin => _selectedCoin;
  get amount => _amount;
  get interest => _interest;
  get selectedDate => _selectedDateTime;
  get selectedTime => _selectedTime;
  get selectedDay => _selectedDay;
  get selectedDayOfWeek => _selectedDayOfWeek;
  get periodValid => _periodValid;

  changeName(text) {
    _name = text;
    notifyListeners();
  }

  changePeriodicity(Periodicity period) {
    _periodicity = period;
    notifyListeners();
  }

  changePaymentPeriod(Periodicity period) {
    _paymentPeriod = period;
    notifyListeners();
  }

  changeCoin(Coin newCoinValue) {
    _selectedCoin = newCoinValue;
    notifyListeners();
  }

  togleIsCreditor() {
    _isCreditor = !_isCreditor;
    notifyListeners();
  }

  changeAmount(value) {
    _amount = value;
    notifyListeners();
  }

  changeInterest(value) {
    _interest = value;
    notifyListeners();
  }

  changeDate(DateTime date) {
    _selectedDateTime = date;
    _periodValid = true;
    notifyListeners();
  }

  changeTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  changeDay(int day) {
    _selectedDay = day;
    notifyListeners();
  }

  changeDayOfWeek(Days day) {
    _selectedDayOfWeek = day;
    notifyListeners();
  }

  clear() {
    _isCreditor = true;
    _periodicity = Periodicity.annually;
    _paymentPeriod = Periodicity.once;
    _selectedCoin = Coin.bs;
    _amount = null;
    _interest = '0';
    _name = null;
    _selectedDateTime = null;
    _selectedTime = TimeOfDay(hour: 9, minute: 0);
    _selectedDay = 1;
    _selectedDayOfWeek = Days.friday;
    _periodValid = null;
  }

  save(context) async {
    final allValid = validateAll();
    if (!allValid) {
      notifyListeners();
    } else {
      Debt newDebt = _generateDebt(context);
      await _debtService.createDebt(newDebt).then((value) {
        clear();
        Navigator.pushNamed(context, initialRoute);
      }).catchError((error) {
        _errorMessage =
            'Algun error con la conexion al servidor impide crear la deuda';
        notifyListeners();
      });
    }
  }

  validateAll() {
    final nameValid = validateName();
    final amountValid = validateAmount();
    final interestValid = validateInterest();
    final periodValidT = validatePeriod();
    return nameValid && amountValid && interestValid && periodValidT;
  }

  validatePeriod() {
    switch (_paymentPeriod) {
      case Periodicity.once:
      case Periodicity.annually:
        final valid = _selectedDateTime != null;
        _periodValid = valid;
        return valid;
      default:
        _periodValid = true;
        return true;
    }
  }

  validateName() {
    if (_name == null) {
      _name = '';
      return false;
    }
    return _name.length > 1;
  }

  validateAmount() {
    if (_amount == null) {
      _amount = '';
      return false;
    }
    return validateNumber(_amount, 1);
  }

  validateInterest() {
    if (_interest == null) {
      _interest = '';
      return false;
    }
    return validateNumber(_amount);
  }

  validateNumber(textNumber, [min = 0]) {
    try {
      return num.parse(textNumber) >= min;
    } on Exception {
      return false;
    }
  }

  _generateDebt(context) {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    return Debt(
      amount: Amount(
        currency: _selectedCoin,
        originalAmount: num.parse(_amount),
      ),
      createdAt: DateTime.now(),
      creditor: _isCreditor ? sessionProvider.user.id : _name,
      debtor: !_isCreditor ? sessionProvider.user.id : _name,
      interest: Interest(
        percent: num.parse(_interest),
        period: _periodicity,
      ),
      paymentPeriod: PaymentPeriod(
        date: _selectedDateTime,
        day: _selectedDay,
        dayOfWeek: _selectedDayOfWeek,
        period: _paymentPeriod,
        time: _selectedTime,
      ),
      payments: [],
      updates: [],
    );
  }
}
