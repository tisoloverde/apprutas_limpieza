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
  List<String> days = [];
  String comuna = '';
  String startPoint = '';
  String endPoint = '';
  String startTime = '';
  String endTime = '';
  String color = '';
  List<Position> coords = [];

  RoutePlan();

  RoutePlan.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        days = json['days'],
        comuna = json['comuna'],
        startPoint = json['startPoint'],
        endPoint = json['endPoint'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        color = json['color'],
        coords = Data.transformListPosition(json['coords']);
}
