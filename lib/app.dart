import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:solo_verde/blocs/base/base.bloc.dart';

import 'package:solo_verde/screens/routes.dart';

import 'package:solo_verde/values/theme.dart' as apptheme;

import 'package:solo_verde/config/app.config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        title: "Recolección de Residuos",
        theme: apptheme.theme,
        routes: Routes.paths,
        initialRoute: Routes.initialPath,
        debugShowCheckedModeBanner: AppConfig.debugTagSimulator,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
      ),
    );
  }
}
