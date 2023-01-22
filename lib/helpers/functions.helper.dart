class Functions {
  static Future<bool> sleepSeconds(int seconds) {
    return Future.delayed(Duration(seconds: seconds)).then((val) => true);
  }

  static Future<bool> sleepMiliseconds(int miliseconds) {
    return Future.delayed(Duration(milliseconds: miliseconds))
        .then((val) => true);
  }
}
