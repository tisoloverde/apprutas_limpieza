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
}

class RoutePlan {
  String name = '';
  String startPoint = '';
  String endPoint = '';
  String color = '';
  List<Position> coords = [];

  RoutePlan();

  RoutePlan.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        startPoint = json['startPoint'],
        endPoint = json['endPoint'],
        color = json['color'],
        coords = Data.transformListPosition(json['coords']);
}
