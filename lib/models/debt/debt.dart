import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loans/models/enums.dart';
import 'package:loans/utils/utils.dart';

class Debt {
  String id;
  String debtor;
  String creditor;
  String reason;
  DateTime createdAt;
  List<DateTime> updates;
  Amount amount;
  Interest interest;
  PaymentPeriod paymentPeriod;
  List<Payment> payments;

  Debt(
      {this.id,
      this.debtor,
      this.creditor,
      this.reason,
      this.createdAt,
      this.updates,
      this.amount,
      this.interest,
      this.paymentPeriod,
      this.payments});

  num calculateAmountPaid() {
    final paymentsAmount = payments
        .fold(0, (previousValue, payment) => previousValue + payment.amount);
    return paymentsAmount;
  }

  num calculateEarnedInterest() {
    return amount.originalAmount * (interest.percent / 100);
  }

  num calculateAmountToPay() {
    return (calculateEarnedInterest() + amount.originalAmount) -
        calculateAmountPaid();
  }

  factory Debt.fromJson(Map json) {
    return Debt(
      id: json['_id'],
      debtor: json['debtor'],
      creditor: json['creditor'],
      reason: json['reason'],
      createdAt: DateTime.parse(json['createdAt']),
      updates: updatesFromJson(json['updates']),
      amount: Amount.fromJson(json['amount']),
      interest: Interest.fromJson(json['interest']),
      paymentPeriod: PaymentPeriod.fromJson(json['paymentPeriod']),
      payments: paymentsFromJson(json['payments']),
    );
  }

  toJson() {
    return {
      '_id': id,
      'debtor': debtor,
      'creditor': creditor,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'updates': updatesToJson(),
      'amount': amount.toJson(),
      'interest': interest.toJson(),
      'paymentPeriod': paymentPeriod.toJson(),
      'payments': paymentsToJson(),
    };
  }

  updatesToJson() {
    return List<DateTime>.from(updates).map((update) {
      update.toIso8601String();
    }).toList();
  }

  paymentsToJson() {
    return List<Payment>.from(payments).map((payment) {
      return payment.toJson();
    }).toList();
  }
}

class Amount {
  num originalAmount;
  num lastAmount;
  Coin currency;
  Amount({
    this.originalAmount,
    this.lastAmount,
    this.currency,
  });

  factory Amount.fromJson(Map json) {
    return Amount(
      originalAmount: json['originalAmount'],
      lastAmount: json['lastAmount'],
      currency: toEnum(Coin.values, json['currency']),
    );
  }

  toJson() {
    return {
      'originalAmount': originalAmount,
      'lastAmount': lastAmount,
      'currency': describeEnum(currency),
    };
  }
}

class Interest {
  num percent;
  Periodicity period;
  Interest({this.percent, this.period});

  factory Interest.fromJson(Map json) {
    return Interest(
      percent: json['percent'],
      period: toEnum(Periodicity.values, json['period']),
    );
  }
  toJson() {
    return {
      'percent': percent,
      'period': describeEnum(period),
    };
  }
}

class PaymentPeriod {
  Periodicity period;
  int day;
  DateTime date;
  TimeOfDay time;
  Days dayOfWeek;
  PaymentPeriod({
    this.period,
    this.day,
    this.date,
    this.time,
    this.dayOfWeek,
  });
  factory PaymentPeriod.fromJson(Map json) {
    final splitted = json['time']?.split(':');
    return PaymentPeriod(
      period: toEnum(Periodicity.values, json['period']),
      day: json['day'],
      date: json['date'] == null ? null : DateTime.parse(json['date']),
      time: splitted == null
          ? null
          : TimeOfDay(
              hour: int.parse(splitted[0]), minute: int.parse(splitted[1])),
      dayOfWeek: toEnum(Days.values, json['dayOfWeek']),
    );
  }
  toJson() {
    return {
      'period': describeEnum(period),
      'day': day,
      'date': date == null ? null : date.toIso8601String(),
      'time': time == null ? null : '${time.hour}:${time.minute}',
      'dayOfWeek': describeEnum(dayOfWeek),
    };
  }
}

class Payment {
  DateTime date;
  num amount;

  Payment(this.date, this.amount);

  factory Payment.fromJson(Map json) {
    return Payment(
      DateTime.parse(json['date']),
      json['amount'],
    );
  }

  toJson() {
    return {
      'date': date != null ? date.toIso8601String() : null,
      'amount': amount,
    };
  }
}

List<DateTime> updatesFromJson(List jsons) {
  List<DateTime> newUpdates = [];
  jsons?.forEach((update) {
    newUpdates.add(DateTime.parse(update));
  });
  return newUpdates;
}

List<Payment> paymentsFromJson(List payments) {
  List<Payment> newPayments = [];
  payments?.forEach((payment) {
    newPayments.add(Payment.fromJson(payment));
  });
  return newPayments;
}
