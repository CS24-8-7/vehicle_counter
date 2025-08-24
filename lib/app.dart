import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vehicle_counter/providers/locale_provider.dart';
import 'package:vehicle_counter/providers/vehicle_counter_provider.dart';
import 'package:vehicle_counter/screens/splash_screen.dart';
import 'package:vehicle_counter/theme/app_theme.dart';

class VehicleCounterApp extends StatelessWidget {
  final SharedPreferences prefs;
  const VehicleCounterApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(prefs),
        ),
        ChangeNotifierProvider<VehicleCounterProvider>(
          create: (_) => VehicleCounterProvider(prefs),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
