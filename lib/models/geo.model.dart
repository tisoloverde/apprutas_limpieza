import 'package:solo_verde/helpers/data.helper.dart';

class Position {
  late double lat;
  late double lng;

  Position();

  Position.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        lng = json['lng'];
}

class RoutePlan {
  String name = '';
  String startPoint = '';
  String endPoint = '';
  List<Position> coords = [];

  RoutePlan();

  RoutePlan.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        startPoint = json['startPoint'],
        endPoint = json['endPoint'],
        coords = Data.transformListPosition(json['coords']);
}
