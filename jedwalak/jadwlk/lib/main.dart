
import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/pages/HomeScreen.dart';
import 'package:jedwalak/providers/AppModel.dart';
import 'package:jedwalak/providers/HomeIndex.dart';
import 'package:provider/provider.dart';


final AppModel model = AppModel();
void main()async {
  Function duringSplash = () {
    print('Something background process');
    return 1;
  };
  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: prymaryColor));
  await Config.init();
  model.init();
  Map<int, Widget> op = {1:ChangeNotifierProvider(create: (_)=>HomeProvider(0),child: HomeScreen())};

  runApp(ChangeNotifierProvider<AppModel>(
      create: (context) => model,
      child: Consumer<AppModel>(
        builder: (context, model, child) =>MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      fontFamily: 'myfont',
      primaryColor: prymaryColor,
      textTheme: TextTheme(title: TextStyle(fontWeight: FontWeight.bold)),
      primarySwatch: Colors.blue,
    ),
    localizationsDelegates: [ 
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: Locale(Provider.of<AppModel>(context).local),
    home:
    CustomSplash(
        imagePath: Config.getLang()=="ar"?"images/logow.png":"images/logow2.png",
        backGroundColor:prymaryColor,
        animationEffect: 'zoom-in',
        logoSize: 100,
        home: ChangeNotifierProvider(create: (_)=>HomeProvider(0),child: HomeScreen()),
        customFunction: duringSplash,
        duration: 2500,
        type: CustomSplashType.StaticDuration,
        outputAndHome: op,
    ),
    
  )),
      ),
    );
}

