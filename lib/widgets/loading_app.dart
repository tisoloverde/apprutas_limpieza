import 'package:flutter/material.dart';

import 'package:solo_verde/values/colors.dart' as colors;

class Loading extends StatelessWidget {
  final bool inAsyncCall;
  final Widget child;

  const Loading({super.key, required this.inAsyncCall, required this.child});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);

    if (inAsyncCall) {
      Widget layOutProgressIndicator;
      layOutProgressIndicator = const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colors.secondary),
        ),
      );
      final modal = [
        const Opacity(
          opacity: 0.7,
          child: IgnorePointer(child: ModalBarrier(color: Colors.white)),
        ),
        IgnorePointer(child: layOutProgressIndicator)
      ];
      widgetList += modal;
    }

    return Stack(
      alignment: Alignment.center,
      children: widgetList,
    );
  }
}
