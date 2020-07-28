import 'package:flutter/material.dart';
import 'package:loans/models/enums.dart';
import 'package:loans/providers/debt/new_debt_provider.dart';
import 'package:loans/screens/util_functions.dart';
import 'package:loans/utils/internationalization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PeriodicPaymentSection extends StatelessWidget {
  final TextEditingController _dateCtl = TextEditingController();
  final TextEditingController _timeCtl = TextEditingController();
  final TextEditingController _dayCtl = TextEditingController();

  Future<void> selectTime(BuildContext context, timeCtl) async {
    final newDebtProviderNL =
        Provider.of<NewDebtProvider>(context, listen: false);
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: 9, minute: 0));
    if (time != null) {
      newDebtProviderNL.changeTime(time);
    }
  }

  Future<void> selectDate(BuildContext context, selectedDate) async {
    final i18n = AppLocalizations.of(context);
    final newDebtProviderNL =
        Provider.of<NewDebtProvider>(context, listen: false);
    final DateTime picked = await showDatePicker(
        helpText: i18n.translate('helpDate'),
        fieldLabelText: i18n.translate('labelDate'),
        cancelText: i18n.translate('cancel'),
        confirmText: i18n.translate('acept'),
        errorFormatText: i18n.translate('errorFormatDate'),
        errorInvalidText: i18n.translate('errorInvalidDate'),
        locale: i18n.locale,
        initialDatePickerMode: DatePickerMode.year,
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      newDebtProviderNL.changeDate(picked);
    }
  }

  dateField(context) {
    final selectedDate = Provider.of<NewDebtProvider>(context).selectedDate;
    // final dateCtl =
    //     Provider.of<NewDebtProvider>(context, listen: false).dateCtl;

    _dateCtl.text = selectedDate == null
        ? ''
        : DateFormat('dd/MM/yyyy').format(selectedDate);
    return TextField(
      controller: _dateCtl,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('payDate'),
        prefixIcon: Icon(
          Icons.calendar_today,
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        selectDate(context, selectedDate);
      },
    );
  }

  timeField(context) {
    TimeOfDay selectedTime = Provider.of<NewDebtProvider>(context).selectedTime;
    // final timeCtl =
    //     Provider.of<NewDebtProvider>(context, listen: false).timeCtl;
    final twoDigits = (value) => value < 10 ? '0$value' : '$value';

    _timeCtl.text = selectedTime == null
        ? ''
        : '${twoDigits(selectedTime.hour)}:${twoDigits(selectedTime.minute)}';
    return TextField(
      controller: _timeCtl,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.access_time,
        ),
        labelText: AppLocalizations.of(context).translate('hour'),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        selectTime(context, _timeCtl);
      },
    );
  }

  dayField(context) {
    final debtProvider = Provider.of<NewDebtProvider>(context);
    final debtProviderNL = Provider.of<NewDebtProvider>(context, listen: false);
    final twoDigits = (value) => value < 10 ? '0$value' : '$value';

    _dayCtl.text = debtProviderNL.selectedDay == null
        ? ''
        : '${twoDigits(debtProvider.selectedDay)}';
    return TextField(
      controller: _dayCtl,
      decoration: InputDecoration(
        prefix: Text(AppLocalizations.of(context).translate('dayOfMonth')),
        labelText: '',
      ),
      textAlign: TextAlign.center,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final day = await showCustomDayPicker(
          context,
          debtProvider.selectedDay,
        );
        if (day != null) {
          debtProviderNL.changeDay(day);
        }
      },
    );
  }

  dayOfWeekField(context) {
    final debtProvider = Provider.of<NewDebtProvider>(context);
    final debtProviderNL = Provider.of<NewDebtProvider>(context, listen: false);
    return TextFormField(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      initialValue: ' ',
      decoration: InputDecoration(
        labelText: '',
        filled: false,
        suffix: dropDown(
          context,
          Days.values,
          debtProvider.selectedDayOfWeek,
          debtProviderNL.changeDayOfWeek,
          expanded: true,
          hint: Text(AppLocalizations.of(context).translate('payDay')),
        ),
      ),
    );
  }

  periodOption(context, NewDebtProvider provider) {
    switch (provider.paymentPeriod) {
      case Periodicity.annually:
      case Periodicity.once:
        return Row(
          children: <Widget>[
            Expanded(
              child: dateField(context),
              flex: 4,
            ),
            VerticalDivider(),
            Expanded(
              child: timeField(context),
              flex: 3,
            ),
          ],
        );
      case Periodicity.daily:
        return timeField(context);
      case Periodicity.weekly:
        return Row(
          children: <Widget>[
            Expanded(
              child: dayOfWeekField(context),
              flex: 4,
            ),
            VerticalDivider(),
            Expanded(
              child: timeField(context),
              flex: 3,
            ),
          ],
        );
      case Periodicity.monthly:
        return Row(
          children: <Widget>[
            Expanded(
              child: dayField(context),
              flex: 4,
            ),
            VerticalDivider(),
            Expanded(
              child: timeField(context),
              flex: 3,
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final newDebtProvider = Provider.of<NewDebtProvider>(context);
    final newDebtProviderNL =
        Provider.of<NewDebtProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          color: Colors.blueGrey[50],
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: dropDown(
              context,
              Periodicity.values,
              newDebtProvider.paymentPeriod,
              newDebtProviderNL.changePaymentPeriod,
              upperCase: true,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 5),
          child: periodOption(context, newDebtProvider),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: newDebtProvider.periodValid == null ||
                    newDebtProvider.periodValid ||
                    (newDebtProvider.paymentPeriod != Periodicity.once &&
                        newDebtProvider.paymentPeriod != Periodicity.annually)
                ? Container()
                : Text(
                    AppLocalizations.of(context).translate('fillDateField'),
                    style: TextStyle(color: Colors.red),
                  ),
          ),
        )
      ],
    );
  }

  Future<int> showCustomDayPicker(context, selectedItem) async {
    return showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        title: Text(
          AppLocalizations.of(context).translate('selectDay'),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * .7,
          height: 280,
          child: GridView.count(
              crossAxisCount: 5,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 5.0,
              children: List<int>.generate(30, (i) => i + 1).map((int value) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, value);
                  },
                  child: Card(
                    elevation: 0,
                    color: selectedItem == value
                        ? Colors.blueGrey[400]
                        : Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Colors.blueGrey[100],
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                        child: Text(
                      value.toString(),
                      style: TextStyle(
                          color: selectedItem == value
                              ? Colors.white
                              : Colors.grey[800]),
                    )),
                  ),
                );
              }).toList()),
        ),
      ),
    );
  }
}
