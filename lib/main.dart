import 'dart:io';

import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'package:ziberto_vendor/Helper/PushNotificationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziberto_vendor/NewScreen/splash_screen.dart';
import 'Helper/Color.dart';
import 'Localization/Demo_Localization.dart';
import 'Localization/Language_Constant.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: AppColor().colorPrimary(), // status bar color
  ));
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  late SharedPreferences sharedPreferences;
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale) {
    if (mounted)
      setState(
        () {
          _locale = locale;
        },
      );
  }

  @override
  void didChangeDependencies() {
    getLocale().then(
      (locale) {
        if (mounted)
          setState(
            () {
              this._locale = locale;
            },
          );
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Sizer(
        builder: (context, orientation, deviceType) {
      return MaterialApp(
      title: 'Entemarket Vendor',
      theme: ThemeData(
        primarySwatch: primary_app,
        fontFamily: 'opensans',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: _locale,
      localizationsDelegates: [
        CountryLocalizations.delegate,
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en", "US"),
        Locale("zh", "CN"),
        Locale("es", "ES"),
        Locale("hi", "IN"),
        Locale("ar", "DZ"),
        Locale("ru", "RU"),
        Locale("ja", "JP"),
        Locale("de", "DE")
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
        });
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}