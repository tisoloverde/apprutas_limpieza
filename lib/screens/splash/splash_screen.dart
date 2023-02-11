import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:solo_verde/services/location.service.dart';

import 'package:solo_verde/screens/home/home_screen.dart';

import 'package:solo_verde/helpers/functions.helper.dart';

import 'package:solo_verde/config/app.config.dart';

import 'package:solo_verde/values/strings.dart' as strings;

class SplashScreen extends StatefulWidget {
  static String routeName = "/";

  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    LocationService.handleLocationPermission().then((Map<String, dynamic> val) {
      bool flag = val['flag'];
      if (flag) {
        _startTime();
      } else {
        Functions.showModal(context, _modal(val['error']));
      }
    });
  }

  _startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Functions.sleepSeconds(AppConfig.timerLogoInit);
    _screenInit(prefs.getBool(strings.isFirstTime) ?? true);
  }

  _screenInit(bool isFirstTime) {
    String iniScreen = '';
    iniScreen = HomeScreen.routeName;
    Navigator.pushNamed(context, iniScreen);
  }

  Widget body(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Image.asset('assets/logos/logo.jpeg', width: 240),
          ),
        ),
      ],
    );
  }

  // Main:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: body(context),
      ),
    );
  }

  Widget _modal(String error) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            child: const Icon(Icons.close),
            onTap: () => SystemNavigator.pop(),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '¡Advertencia!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            )
          ],
        ),
      ],
    );
  }
}
