import 'package:flutter/material.dart';
import 'package:driverslicenses/ui/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';
import 'shared_pref_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale tempLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(tempLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: AppLocalizations.of(context).translate('tittle'),
      title: "",
      theme: ThemeData(
          primaryColor: Colors.deepPurple[800],
          accentColor: Colors.yellow[700],
          primarySwatch: Colors.orange,
          fontFamily: "Montserrat",
          buttonColor: Colors.deepPurple,
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textTheme: ButtonTextTheme.primary)),
      locale: _locale,

      // List all of the app's supported locales here
      supportedLocales: [const Locale('en', 'US'), const Locale('es', 'ES')],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,

        GlobalCupertinoLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },

      home: HomePage(),
    );
  }

  void setLocale(locale) {
    setState(() {
      _locale = locale;
    });
  }
}
