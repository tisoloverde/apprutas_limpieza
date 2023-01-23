import 'package:solo_verde/models/geo.model.dart';

class Data {
  static List<Position> transformListPosition(var data) {
    if (data == null) return [];
    List<Position> lst = (data as List)
        .map<Position>((item) => Position.fromJson(item))
        .toList();
    return lst;
  }

  static List<RoutePlan> transformListRoutePlan(var data) {
    if (data == null) return [];
    List<RoutePlan> lst = (data as List)
        .map<RoutePlan>((item) => RoutePlan.fromJson(item))
        .toList();
    return lst;
  }
}