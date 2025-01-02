import 'package:vehicle_counter/imports_library.dart';
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  final SharedPreferences _prefs;

  LocaleProvider(this._prefs) {
    final savedLocale = _prefs.getString('locale');
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
  }

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'ar'].contains(locale.languageCode)) return;

    _locale = locale;
    _prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  void toggleLocale() {
    setLocale(Locale(_locale.languageCode == 'en' ? 'ar' : 'en'));
  }
}
