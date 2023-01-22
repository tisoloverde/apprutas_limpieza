import 'package:flutter/material.dart';

import 'package:solo_verde/screens/splash/splash_screen.dart';
import 'package:solo_verde/screens/home/home_screen.dart';

class Routes {
  static String initialPath = SplashScreen.routeName;

  static Map<String, WidgetBuilder> paths = {
    SplashScreen.routeName: (context) => const SplashScreen(),
    HomeScreen.routeName: (context) => const HomeScreen(),
  };
}
