import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solo_verde/blocs/home/home.bloc.dart';

class BlocProvider extends StatelessWidget {
  final Widget child;

  const BlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Provider.debugCheckInvalidValueType = null;

    return MultiProvider(
      providers: [
        Provider<HomeBloc>.value(value: HomeBloc()),
      ],
      child: child,
    );
  }
}
