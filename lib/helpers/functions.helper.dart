import 'package:flutter/material.dart';

import 'package:solo_verde/values/colors.dart' as colors;

class Functions {
  static Future<bool> sleepSeconds(int seconds) {
    return Future.delayed(Duration(seconds: seconds)).then((val) => true);
  }

  static Future<bool> sleepMiliseconds(int miliseconds) {
    return Future.delayed(Duration(milliseconds: miliseconds))
        .then((val) => true);
  }

  static void showSnackBarApp(BuildContext context, String type, String msg) {
    Map<String, Color> mapColorType = {
      'error': colors.danger,
      'warning': colors.warning,
      'success': colors.success,
      'info': colors.info,
    };
    Color colorType = mapColorType[type] ?? colors.info;

    final snackbar = SnackBar(
      content: Row(
        children: <Widget>[
          Container(
            height: 20,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(width: 2, color: colorType)),
            ),
          ),
          const SizedBox(width: 7),
          Icon(
            Icons.error,
            color: colorType,
            size: 20,
          ),
          const SizedBox(width: 7),
          SizedBox(
            width: MediaQuery.of(context).size.width - 180,
            child: Text(
              msg,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: colorType,
                fontSize: 12,
                fontFamily: 'Archivo',
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        side: BorderSide(width: 2, color: colorType),
      ),
      action: SnackBarAction(
        label: 'x',
        textColor: Colors.black,
        onPressed: () {
          //Scaffold.of(context)
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static String onlyTime(DateTime dt) {
    String time = dt.toString();
    List<String> aux = time.split(" ");
    if (aux.length < 2) return "";
    List<String> aux2 = aux[1].split(".");
    if (aux2.length < 2) return "";
    return aux2[0];
  }

  static String cutLongText(String str, {int max = 18}) {
    if (str.isEmpty) return str;
    if (str.length < max) return str;
    String res = str.substring(0, max);
    if (str[str.length - 1] == ' ') res;
    return '$res...';
  }
}
