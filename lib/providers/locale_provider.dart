import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _key = 'locale';
  Locale _locale = const Locale('en');
  final SharedPreferences _prefs;

  LocaleProvider(this._prefs) {
    final saved = _prefs.getString(_key);
    if (saved != null && ['en', 'ar'].contains(saved)) {
      _locale = Locale(saved);
    }
  }

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'ar'].contains(locale.languageCode)) return;
    _locale = locale;
    _prefs.setString(_key, locale.languageCode);
    notifyListeners();
  }

  void toggleLocale() {
    setLocale(Locale(_locale.languageCode == 'en' ? 'ar' : 'en'));
  }
}
