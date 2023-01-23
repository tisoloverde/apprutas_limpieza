import 'package:geolocator/geolocator.dart';

import 'package:solo_verde/helpers/http.helper.dart';

import 'package:solo_verde/config/app.config.dart';

class LocationService {
  static Future<Map<String, dynamic>> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        "flag": false,
        "error": 'Location services are disabled. Please enable the services',
      };
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "flag": false,
          "error": 'Location permissions are denied',
        };
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return {
        "flag": false,
        "error":
            'Location permissions are permanently denied, we cannot request permissions.',
      };
    }
    return {"flag": true};
  }

  static Future<Map<String, double>> currentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return {
      "lat": position.latitude,
      "lng": position.longitude,
    };
  }

  static Future<Map<String, dynamic>> getPlace(String q) async {
    String url = AppConfig.googleMapsApi;
    String k = AppConfig.googleMapsKey;
    url += '/findplacefromtext/json?input=$q&inputtype=textquery&key=$k';
    final response = await HttpRequest().getHttp(url);
    Map<String, dynamic> data = response.data;
    if (data['candidates'].length > 0) {
      String placeId = data['candidates'][0]['place_id'];

      String uri = AppConfig.googleMapsApi;
      uri += '/details/json?place_id=$placeId&key=$k';
      final resp = await HttpRequest().getHttp(uri);
      Map<String, dynamic> dt = resp.data;
      Map<String, dynamic> coord = dt['result'];
      return {
        "lat": coord['geometry']['location']['lat'],
        "lng": coord['geometry']['location']['lng'],
      };
    } else {
      return {};
    }
  }
}
