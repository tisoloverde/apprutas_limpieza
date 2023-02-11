import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
        // "error": 'Location services are disabled. Please enable the services',
        "error":
            "Los servicios de ubicación están deshabilitados. Por favor, habilite los servicios.",
      };
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "flag": false,
          // "error": 'Location permissions are denied',
          "error": "Los permisos de ubicación están denegados.",
        };
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return {
        "flag": false,
        /*"error":
            'Location permissions are permanently denied, we cannot request permissions.',*/
        "error":
            "Los permisos de ubicación están permanentemente denegados, no podemos solicitar los persmisos.",
      };
    }
    return {"flag": true};
  }

  static Future<Map<String, double>> currentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return {
      "oLat": position.latitude,
      "oLng": position.longitude,
    };
  }

  static Future<Map<String, dynamic>> getPlace(String q) async {
    String url = AppConfig.googleMapsApi;
    String k = AppConfig.googleMapsKey;
    url += '/place/findplacefromtext/json?input=$q&inputtype=textquery&key=$k';
    final response = await HttpRequest().getHttp(url);
    Map<String, dynamic> data = response.data;
    if ((data['candidates'] as List).isNotEmpty) {
      String placeId = data['candidates'][0]['place_id'];

      String uri = AppConfig.googleMapsApi;
      uri += '/place/details/json?place_id=$placeId&key=$k';
      final resp = await HttpRequest().getHttp(uri);
      Map<String, dynamic> dt = resp.data;
      Map<String, dynamic> coord = dt['result'];

      double lat = coord['geometry']['location']['lat'];
      double lng = coord['geometry']['location']['lng'];

      List<String> address = await getAddress(lat, lng);
      return {"lat": lat, "lng": lng, "address": address[0]};
    } else {
      return {"error": '¡No se puedo encontrar!'};
    }
  }

  static Future<List<String>> getAddress(double lat, double lng) async {
    String url = AppConfig.googleMapsApi;
    String k = AppConfig.googleMapsKey;
    String resultType = "result_type=administrative_area_level_3";
    url += '/geocode/json?latlng=$lat,$lng&$resultType&key=$k';
    final response = await HttpRequest().getHttp(url);
    Map<String, dynamic> data = response.data;
    String address = "Desconocido";
    String comuna = "";
    if (data['results'].isNotEmpty) {
      address = data['results'][0]['formatted_address'];
      for (var ac in data['results'][0]['address_components']) {
        if ((ac['types'] as List).contains('administrative_area_level_3')) {
          comuna = ac['short_name'];
          break;
        }
      }
    }
    return [address, comuna];
  }

  static Future<Polyline> getPolyline(
    String id,
    Color color,
    double oLat,
    double oLng,
    double fLat,
    double fLng,
  ) async {
    String k = AppConfig.googleMapsKey;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      k,
      PointLatLng(oLat, oLng),
      PointLatLng(fLat, fLng),
      travelMode: TravelMode.driving,
      // wayPoints: [PolylineWayPoint(location: "Chile")],
    );
    List<LatLng> points = [];
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        points.add(LatLng(point.latitude, point.longitude));
      }
    }

    final Polyline polyline = Polyline(
      polylineId: PolylineId('_kPolyline_$id'),
      points: points,
      color: color,
    );

    return polyline;
  }
}
