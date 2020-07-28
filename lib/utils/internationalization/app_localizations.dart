import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:loans/utils/internationalization/app_localization_delegate.dart';
import 'package:yaml/yaml.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  // Map<String, String> _localizedStrings;

  // Future<bool> load() async {
  //   String jsonString =
  //       await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
  //   Map<String, dynamic> jsonMap = json.decode(jsonString);

  //   _localizedStrings = jsonMap.map((key, value) {
  //     return MapEntry(key, value.toString());
  //   });

  //   return true;
  // }
  YamlMap _localized;
  Future load() async {
    String yamlString =
        await rootBundle.loadString('assets/i18n/${locale.languageCode}.yaml');
    _localized = loadYaml(yamlString);
  }

  String translate(String key) {
    try {
      final keys = key.split('.');
      dynamic res = _localized;
      keys.forEach((item) {
        res = res[item];
      });
      return res ?? 'Key[$key] not found';
    } on Exception {
      return 'Key[$key] not found';
    }
  }
}
