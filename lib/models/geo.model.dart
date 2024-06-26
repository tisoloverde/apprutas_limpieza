import 'package:solo_verde/helpers/data.helper.dart';

class Position {
  late double oLat;
  late double oLng;
  late double fLat;
  late double fLng;

  Position();

  Position.fromJson(Map<String, dynamic> json)
      : oLat = json['oLat'] ?? 0.0,
        oLng = json['oLng'] ?? 0.0,
        fLat = json['fLat'] ?? 0.0,
        fLng = json['fLng'] ?? 0.0;

  Position.fromPair(double lat, double lng)
      : oLat = lat,
        oLng = lng;

  toCoordStr() => "$oLat,$oLng";
}

class RoutePlan {
  String name = '';
  List<String> days = [];
  String comuna = '';
  String vehicle = '';
  String startPoint = '';
  String endPoint = '';
  String startTime = '';
  String endTime = '';
  String color = '';
  bool isCloser = false;
  List<Position> coords = [];

  RoutePlan();

  RoutePlan.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        days = Data.transformListDay(json['days']),
        comuna = json['comuna'],
        vehicle = json['vehicle'],
        startPoint = json['startPoint'],
        endPoint = json['endPoint'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        color = json['color'],
        isCloser = json['isCloser'] ?? false,
        coords = Data.transformListPosition(json['coords']);
}
