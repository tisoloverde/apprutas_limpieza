import 'package:flutter/material.dart';

import 'package:solo_verde/values/colors.dart' as colors;

class HomeScreen extends StatefulWidget {
  static String routeName = "/login";

  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) return;
    setState(() => _isInit = false);
    // _bloc.init();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Main:
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _key,
        backgroundColor: colors.background,
        body: const SizedBox(),
      ),
    );
  }
}
