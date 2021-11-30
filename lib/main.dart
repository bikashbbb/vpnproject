import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:nizvpn/core/utils/preferences.dart';
import 'package:nizvpn/ui/screens/introScreen.dart';
import 'package:provider/provider.dart';

import 'core/provider/adsProvider.dart';
import 'core/provider/purchaseProvider.dart';
import 'core/provider/uiProvider.dart';
import 'core/provider/vpnProvider.dart';
import 'core/resources/warna.dart';
import 'ui/screens/mainScreen.dart';
import 'ui/screens/privacyPolicyScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await EasyLocalization.ensureInitialized();
  // rootBundle.loadString(key)

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VpnProvider()),
        ChangeNotifierProvider(create: (context) => PurchaseProvider()),
        ChangeNotifierProvider(create: (context) => AdsProvider()),
        ChangeNotifierProvider(create: (context) => MainScreenProvider()),
        ChangeNotifierProvider(create: (context) => UIProvider()),
      ],
      child: Consumer<UIProvider>(
        builder: (context, value, child) => EasyLocalization(
          path: 'assets/languages',
          startLocale: value.selectedLocale ?? Locale("en", "US"),
          supportedLocales: value.locales!,
          useOnlyLangCode: true,
          child: Root(),
        ),
      ),
    ),
  );
}

class Root extends StatefulWidget {
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  bool ready = false;
  @override
  void initState() {
    if (Platform.isAndroid)
      InAppUpdate.checkForUpdate().then((value) {
        if (value.flexibleUpdateAllowed)
          return InAppUpdate.startFlexibleUpdate()
              .then((value) => InAppUpdate.completeFlexibleUpdate());
        if (value.immediateUpdateAllowed)
          return InAppUpdate.performImmediateUpdate();
      });

    UIProvider.initializeLanguages(context);
    PurchaseProvider.initPurchase(context);
    VpnProvider.instance(context).initialize();
    VpnProvider.refreshInfoVPN(context);

    if (!ready)
      setState(() {
        ready = true;
      });

    Future.delayed(Duration(seconds: 8)).then((value) {
      if (!ready)
        setState(() {
          ready = true;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        theme: ThemeData(
            checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                    width: 2, color: Colors.white38),
                splashRadius: 0),
            primaryColor: primaryColor,
            fontFamily: GoogleFonts.poppins().fontFamily,
            scaffoldBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                textStyle:
                    MaterialStateProperty.all(TextStyle(color: Colors.black)),
              ),
            ),
            buttonTheme: ButtonThemeData(
              focusColor: Colors.grey.shade300,
            ),
            appBarTheme: AppBarTheme(
              color: Colors.white,
            )),
        home: ready
            ? FutureBuilder<Preferences>(
                future: Preferences.init(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (!snapshot.data!.firstOpen)
                      return IntroScreen(rootState: this);
                    if (snapshot.data!.privacyPolicy) {
                      return MainScreen();
                    } else {
                      return PrivacyPolicyIntroScreen(rootState: this);
                    }
                  } else {
                    return SplashScreen();
                  }
                },
              )
            : SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/19.png'))),
    ));
  }
}
