import 'package:connectivity/connectivity.dart';

class Connection {
  static ConnectivityResult? connectivityResult;

  static Future connect() async {
    connectivityResult = await Connectivity().checkConnectivity();
  }

  static Future<bool> hasConnection() async {
    bool flag = false;
    await connect();
    flag = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    return flag;
  }

  static Stream<ConnectivityResult> connectionListener() {
    return Connectivity().onConnectivityChanged;
  }
}
